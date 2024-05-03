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

### Usage

In powershell teminal launch: gdns-ingress-ip-switch.ps1 and select GCP DNS Zone and namespace to get ip from ingress. Done.

#
[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](https://choosealicense.com/licenses/mit/)
