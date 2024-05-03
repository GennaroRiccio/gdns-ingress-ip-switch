<img src="/asset/Designer.jpeg" width="80%" height ="80%" >

# gdns-ingress-ip-switch
Update Google DNS IP from ingress namespace

If you need to update the ip dns of an ingress this small utility helps with the task.
the script was born for GCP used the gcloud cli, but can be easily adapted for any cloud vendor.

### Requirements

* Kubectl (with access to K8S Cluster)
* Gcloud cli (with access and auth on GCP with correct grants)
* Powershell v7+
* PwshSpectreConsole

<p><a href="https://cloud.google.com" target="_blank" rel="noreferrer"> <img src="https://www.vectorlogo.zone/logos/google_cloud/google_cloud-icon.svg" alt="gcp" width="40" height="40"/> </a> 
<a> <img src="https://raw.githubusercontent.com/PowerShell/PowerShell/master/assets/ps_black_64.svg?sanitize=true" alt="powershell" width="40" height="40"/> </a> <a href="https://kubernetes.io" target="_blank" rel="noreferrer"> <img src="https://www.vectorlogo.zone/logos/kubernetes/kubernetes-icon.svg" alt="kubernetes" width="40" height="40"/> </a>  </p>

### Usage

In powershell teminal launch: gdns-ingress-ip-switch.ps1 and select GCP DNS Zone and namespace to get ip from ingress. Done.

#
[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](https://choosealicense.com/licenses/mit/)
