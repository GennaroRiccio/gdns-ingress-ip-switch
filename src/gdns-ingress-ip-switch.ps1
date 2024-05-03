###################################################################################################################################
#--------------------------------
# GoogleDNS-Ingress-Ip-Switch v0.1
# Descrizione: Aggiorna IP DNS Google da ingress namespace
# by Gennaro Riccio 2024-04-30 09:34:02
# latest change 2024-05-02 15:11:36 #GR
# -------------------------------
###################################################################################################################################
Import-Module PwshSpectreConsole
class TableIp {
    [String] $Dns
    [String] $Ip
}
class RecordSet {
    [String] $Name
    [String] $Type
    [String] $TTL
    [String] $Data
}
function Get-Zones {
    $zones=gcloud dns managed-zones list    
    $i=0
    $listZone=@()
    foreach($z in $zones){        
        if ($i -eq 0){
            $i+=1
            Continue
        }
        $a=$z.split(' ')        
        $listZone += $a[0]
        $i+=1
        }
    $listZone
}
function Get-Namespaces {
    kubectl get ns --no-headers -o custom-columns=":metadata.name"    
}

function Get-NamespaceIngressIp {
    param (
        [Parameter(Mandatory=$true)]
        [String] $NameSpace
    )
    [System.Collections.ArrayList]$listTable = @()
    $IpAddrs = kubectl get ingress -n $nameSpace --no-headers -o custom-columns=":.spec.rules[0].host,:.status.loadBalancer.ingress[0].ip"
    foreach ($a in $IpAddrs){
        $IpTable=[TableIp]::new()
        $c = $a.Split(' ') | Where-Object {!$_.trim() -eq ""}
        $IpTable.Dns = $c[0]
        $IpTable.Ip = $c[1]
       [void]$listTable.Add($IpTable)
    }
    return $listTable
}
function Get-DnsIpAdress {
    param (
        [Parameter(Mandatory=$true)]
        [String] $Zone
    )    
    [System.Collections.ArrayList]$listRs = @()
    $gcRs = gcloud dns record-sets list --zone=$Zone
    $i=0
    foreach($r in $gcRs){
        if ($i -eq 0 ) {$i+=1 ; Continue}
        $Rs = [RecordSet]::new()
        $record = $r.split(' ') | Where-Object {!$_.trim() -eq ""}
        $Rs.Name = $record[0]
        $Rs.Type = $record[1]
        $Rs.TTL = $record[2]
        $Rs.Data = $record[3]
        [void]$listRs.Add($Rs) 
        $i+=1
    }
    return $listRs
}
Clear-Host

Write-SpectreRule -Title "Google DNS Ingress IP Switch v0.1 By #GR 2024" -Alignment Center -Color Red

if ($args.Length -eq 0){    
    $listaZone = Invoke-SpectreCommandWithStatus -Spinner "Dots2" -Title "Get DNS Zones..." -ScriptBlock {
     
        return Get-Zones
    }    
    $Zone = Read-SpectreSelection -Title "Select Google Zone" -Choices $listaZone -Color "Green" -EnableSearch
    Write-SpectreHost "Zona : [Green]'$Zone'[/]"
    
    $nsList = Invoke-SpectreCommandWithStatus -Spinner "Dots2" -Title "Get K8s Namespaces..." -ScriptBlock {     
        return Get-Namespaces 
    }   

    $nameSpace = Read-SpectreSelection -Title "Select Ingress NameSpace to DNS Update" -Choices $nsList -Color "Green" -EnableSearch
    Write-SpectreHost "NameSpace : [Green]'$nameSpace'[/]"
    $NsIpAddrs = Invoke-SpectreCommandWithStatus -Spinner "Dots2" -Title "Get K8s Namespaces..." -ScriptBlock {     
        return Get-NamespaceIngressIp $nameSpace 
    }   
    Write-SpectreHost "Ingress DNS Ip for [Green]'$nameSpace'[/]"        
    Format-SpectreTable -Data $NsIpAddrs -Wrap    
}
Write-SpectreHost "Get DNS Ip for Zone [Green]'$Zone'[/]"        
$rsZone = Invoke-SpectreCommandWithStatus -Spinner "Dots2" -Title "Get Ip Zone: $($Zone) " -ScriptBlock {     
    return Get-DnsIpAdress $Zone
}   
Format-SpectreTable -Data $rsZone -Wrap

foreach ($i in $NsIpAddrs) {
    Write-SpectreHost "DNS Ip Change for -> $($i.Dns) "        
    Write-SpectreHost "[Red]gcloud dns record-sets update $($i.Dns+'.') --rrdatas=$($i.Ip) --zone=$($Zone) --type=A --ttl=300 -> Update[/]"
    $DnsName="$($i.Dns)."
    $newIp = "$($i.Ip)"
    gcloud dns record-sets update $DnsName --rrdatas=$newIp --zone=$Zone --type=A --ttl=300
}
$rsZone = Invoke-SpectreCommandWithStatus -Spinner "Dots2" -Title "Get Ip Zone: $($Zone) " -ScriptBlock {     
    return Get-DnsIpAdress $Zone
}   
Format-SpectreTable -Data $rsZone -Wrap