# ELB Sandwich with ASG of Barracuda NextGen Firewalls

## Introduction
This template deploys an Auto-Scaling Group of NextGen Firewalls into a new VPC, together with a downstream ILB forming a complete ELB Sandwich architecture. Firewall policy is automatically adjusted to allow connectivity through the sandwich for TCP ports 80 and 443. The auto scaling policy based on network packets metrics is installed by default.

![ELB Sandwich Netowork Architecture](https://campus.barracuda.com/resources/attachments/image/70584069/aws_remote_access_autoscaling_group.png)

## Prerequisites
Before attempting to deploy the solution you must create an IAM Role for Barracuda NextGen Firewalls. See [How to Create an IAM Role for an F-Series Firewall in AWS](https://campus.barracuda.com/product/nextgenfirewallf/article/NGF71/AWSCreateIAMRoleFW/) for details.

Solution does not check for availability of requested instance types in a given region. Please consult AWS documentation for instance type availability. Barracuda recommends use of **m4** or **c4** series. Using unavailable instance type will result in ASG not meeting the required initial size and thus failing CloudFormation deployment.

## Deployed resources
Following resources will be created by the template:
- One VPC with public and private subnets in 2 Availability Zones
- Two Elastic Load Balancers for management and production traffic
- One Internal Load Balancer for the backend workload nodes
- S3 bucket used for configuration and updates synchronization
- Auto Scaling Group with proper Launch Configuration and Scaling Policies
- additional helper elements: routes, Internet Gateway, NAT Gateways, SNS topic and SQS queues.

**Note** The backend subnets and resources are *not* automatically created by the template. This has to be done manually after template deployment has finished.


## Template Parameters
Parameter Label | Parameter Name | Description
---|---|---
Minimum Size | InitialSize | Initial size of the Auto Scaling Group.
Maximum Size | MaxSize | Maximum number of instances in the Auto Scaling Group.
Scale-out Trigger | HighThreshold | Maximum number of network packets per instance.
Scale-In Trigger | LowThreshold | Number of packets per instance to trigger scaling in.
Instance Type | InstanceType | Select the EC2 instance type.
IAM Profile | IAMProfile | Select the IAM Role for the NextGen Firewall.
VPC Address | VpcAddress | IP address space for new VPC
Private Subnet in Zone A | PrivateSubnetAAddress | Private subnet hosting firewalls in A zone. Must be within VPC address space.
Public Subnet in Zone A | PublicSubnetAAddress | Public helper subnet in A zone. Must be within VPC address space.
Private Subnet in Zone B | PrivateSubnetBAddress | Private subnet hosting firewalls in B zone. Must be within VPC address space.
Public Subnet in Zone B | PublicSubnetBAddress | Public helper subnet in B zone. Must be within VPC address space.

## Launching the Template
For instructions on how to launch a CloudFormation Template, consult AWS documentation or check [How to Deploy an F-Series Firewall in AWS via CloudFormation Template](https://campus.barracuda.com/product/nextgenfirewallf/article/NGF71/AWSDeployCloudFormationTemplate/) article in Barracuda Campus.

## Additional Resources
