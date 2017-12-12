## Deploy Cold Standby cluster into an existing VpcId

[NGF_Coldstandby-BYOL-existing-VPC.json](NGF_Coldstandby-BYOL-existing-VPC.json) allows you to deploy the cold standby cluster with managed NGF into an already existing VPC. This template is design to work with BYOL NGF instance with pool license managed by NGCC.

This template reports status of PAR file retrieval as a custom tag assigned to ASG.

### Prerequisites
The existing VPC must include following resources:
- two subnets in different AZs for hosting firewall instance
- route table with a default route (destination 0.0.0.0/0), which will be updated with firewall instance id

Optionally existing VPC can export following outputs (so you can provide only the prefix):
 - [prefix]-VpcId
 - [prefix]-PublicSubnetAId
 - [prefix]-PublicSubnetBId
 - [prefix]-PrivateSubnetRouteTableId

You can create a VPC meeting above reuqirements using [vpc.json](vpc.json) template.

### Parameters
Parameter name | Default value | Description
---------------|-------------|---
InstanceType | t2.medium | Type of instance, make sure the selected type is available in your region (template cannot check it itself)
IAMProfile | NextGenFirewallRole | Type in the name you used when creating the IAM role. See [How to Create an IAM Role for an F-Series Firewall in AWS](https://campus.barracuda.com/product/nextgenfirewallf/article/NGF71/AWSCreateIAMRoleFW/) for details.
VpcStackName | | Name of stack you used to create a VPC if you want optional exports (see optional prerequisites above) to be cross-referenced between stacks. Leave empty and fill in rest of parameters for manual matching
VpcId | | (void if VPCStackName is used) Id of VPC to deploy to
PublicSubnetAId | | (void if VPCStackName is used) Id of subnet in first AZ to deploy to
PublicSubnetBId | | (void if VPCStackName is used) Id of subnet in second AZ to deploy to
PrivateSubnetRouteTableId | | (void if VPCStackName is used) Id of route table, which default route will be pointed to new firewall instance.
CCIPAddress | | IP address of NG Control Center server
CCRange | | Range Id in NG Control Center
CCCluster | | Cluster name in NG Control Center
CCBoxname | | Name of this firewall box as declared in NG Control Center
CCUser | | (optional) NGCC administrator username to retrieve configuration data
CCPassword | | Password for administrator username or PAR Retrieval Shared Key (if user is empty)

### How to deploy

Create the VPC:
```
aws cloudformation deploy --template-file vpc.json --stack-name my-vpc --parameter-override ZoneA=eu-west-1b ZoneB=eu-west-1d
```


Deploy the solution:
```
aws cloudformation deploy --template-file NGF_Coldstandby-BYOL-existing-VPC.json --stack-name my-ngfw --parameter-overrides VpcStackName=my-vpc,CCIpAddress=1.1.1.1,CCRange=1,CCCluster=aws-my-ngfw,CCBoxname=my-ngfw,CCPassword=secret
```
