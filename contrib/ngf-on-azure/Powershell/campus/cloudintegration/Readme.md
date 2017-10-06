# Cloud Integration PowerShell Script for the Barracuda NextGen Firewall F
To use your NextGen Firewall in Azure to its fullest extent, the firewall must be configured to allow it to connect to the underlying cloud fabric. Using REST API calls, the firewall retrieves platform-specific data, or connects to other cloud services.

## Required Azure PowerShell Version
Use Azure PowerShell 4.3.1 or newer. If in doubt always use the latest Azure PowerShell version.
Check the PowerShell version with the following command:
```
Get-Module -ListAvailable -Name Azure -Refresh
```
## Step-by-Step Instructions on Barracuda Campus
Follow the instructions on Barracuda Campus to utilize this script correctly. Just running the script is not enough, you must generate certificates and configure the firewall VM to complete the Cloud Integration configuration.
For more information, see [Barracuda Campus](https://campus.barracuda.com/product/nextgenfirewallf/doc/53248675/how-to-configure-azure-cloud-integration-using-arm).

## Acknowlegments
Thanks to everybody who contributed to this script.
