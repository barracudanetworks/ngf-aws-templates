# Managed Box - Barracuda NextGen Firewall Template for AWS

## Introduction
Managed Box solution deploys a single NextGen Firewall instance into a pre-existing subnet and binds it to NextGen Control Center. Template can be used to deploy NextGen Firewalls as well as Secure Access Concentrators, as the two products share the same image.

New instance sill be assigned a public IP, no changes to subnet routing is performed.

## Prerequisites
1. You need a NextGen Control Center (NGCC) running and the box configured before deploying. This template will make the new instance automatically connect to your NGCC and download its configuration.
1. A VPC with public subnet must exist prior to deploying an instance using this template. The subnet to deploy to must allow network access to your NGCC
1. IAM role must exist if you plan to use it (e.g. if you're building an HA cluster)

## Deployed resources
One EC2 Instance with a single NIC and a public IP attached.

## Note
Authentication using PAR File Retrieval Key is currently supported for BYOL instances only. When deploying a managed PAYG instance, you must use username and password to bind to NGCC.

## Template Parameters

CFT Label | Parameter Name |  Description
---|---|---
Instance Type | InstanceType | Type of instance to deploy. Please choose one available in your region.
LicenceMode | Licence Mode | Type of license to use (PAYG or BYOL).
Private IP Address | PrivateIpAddress | (optional) Static private IP address for AWS instance. This is required if your NGF will be a part of HA cluster.
VPC Physical ID | VPCId | AWS ID of VPC to deploy into.
Subnet Physical ID | SubnetId | AWS ID of subnet to deploy into.
IAM Profile | IAMProfile | (optional) IAM role name to be assigned with the instance. Recommended for automatic route shifting in HA clusters.
Control Center IP Address | CCIPAddress | IP address or FQDN of the Control Center.
Control Center Range ID | CCRange | Id of NGCC Range hosting box configuration.
Control Center Cluster Name | CCCluster | Name of NGCC cluster hosting box configuration.
Box Name | CCBoxname | Box name as defined in NGCC.
Control Center username | CCUser | (optional for BYOL) Username to use to authenticate against NGCC.
Control Center Password/key | CCPassword | Password to use to authenticate against NGCC. If username is empty, password value will be used as a shared key to bind instance to NGCC (see Box Properties/Operational/PAR File Retrieval Key).



## Launching the Template
For instructions on how to launch a CloudFormation Template, consult AWS documentation or check [How to Deploy an F-Series Firewall in AWS via CloudFormation Template](https://campus.barracuda.com/product/cloudgenfirewall/doc/96026606/) article in Barracuda Campus.

## Additional Resources
