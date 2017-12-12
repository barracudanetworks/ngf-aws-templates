## Deploy Cold Standby cluster into an existing VpcId

[NGF_Coldstandby-PAYG-existing-VPC.json](NGF_Coldstandby-PAYG-existing-VPC.json) allows you to deploy the solution into an already existing VPC.

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
VpcId | | Id of VPC to deploy to
PublicSubnetAId | | Id of subnet in first AZ to deploy to
PublicSubnetBId | | Id of subnet in second AZ to deploy to
PrivateSubnetRouteTableId | | Id of route table, which default route will be pointed to new firewall instance.

### How to deploy

Create the VPC:
```
aws cloudformation deploy --template-file vpc.json --stack-name my-vpc --parameter-override ZoneA=eu-west-1b ZoneB=eu-west-1d
```


Deploy the solution:
```
aws cloudformation deploy --template-file NGF_Coldstandby-PAYG-existing-VPC.json --stack-name my-ngfw --parameter-overrides VpcStackName=my-vpc
```
