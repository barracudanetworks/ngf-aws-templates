# Auto Scaling Group - Barracuda NextGen Firewall Template for AWS

## Introduction
This solution deploys to AWS EC2 an auto scaling group of Barracuda NextGen Firewalls (NGF). Firewall instances are synchronized and deployed behind an Elastic Load Balancer, which makes them visible and acting as a single system. The ASG is by default automatically scaled out/in based on number of concurrent VPN connections.

![ASG architecture diagram](https://campus.barracuda.com/resources/attachments/image/70584069/aws_autoscale_cluster_plain.png)

## Prerequisites

Before attempting to deploy the solution you must create an IAM Role for Barracuda NextGen Firewalls. See [How to Create an IAM Role for an F-Series Firewall in AWS](https://campus.barracuda.com/product/nextgenfirewallf/article/NGF71/AWSCreateIAMRoleFW/) for details.

Solution does not check for availability of requested instance types in a given region. Please consult AWS documentation for instance type availability. Barracuda recommends use of **m4** or **c4** series. Using unavailable instance type will result in ASG not meeting the required initial size and thus failing CloudFormation deployment.

If you plan to use SSLVPN functionality in NGF, you need to provide the solution with ARN of your SSL certificate hosted in AWS Certificate Manager. For details on how to how to use ACM see [Working with Server Certificates](http://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_server-certs.html) in AWS documentation.

## Deployed Resources

Following resources will be created by the template:
- One VPC with public and private subnets in 2 Availability Zones
- Two Elastic Load Balancers for management and production traffic
- S3 bucket used for configuration and updates synchronization
- Auto Scaling Group with proper Launch Configuration and Scaling Policies
- additional helper elements: routes, Internet Gateway, NAT Gateways, SNS topic and SQS queues.

Note, that for most of the deployed resources, names are automatically created using ASG name parameter as prefix.

## Template Parameters

| CFT Label | Parameter Name |  Description |
|---------------|------------|---------------------|
| Minimum Size | InitialSize | Minimum (and initial) size of ASG. |
| Maximum Size | MaxSize | Maximum size the ASG is allowed to reach. |
| Scale-out Trigger | HighThreshold | Maximum average VPN clients per instance triggering scaling out of ASG. |
| Scale-in Trigger | LowThreshold | Minimum average VPN clients per instance triggering scaling in of ASG. |
| Instance Type | InstanceType | Instance type to use for NGF instances. Please choose one available in your region. |
| IAM Profile | IAMProfile | IAM profile to be assigned to instances. |
| VPC Address | VpcAddress | IP address space for newly created VPC. |
| Zone A Availability Zone | AZone | Availability Zone to use for "Zone A" |
| Zone B Availability Zone | BZone | Availability Zone to use for "Zone B" |
| Private Subnet in Zone A | PrivateSubnetAAddress | Subnet address for hosting NGF instances in zone A. |
| Private Subnet in Zone B | PrivateSubnetBAddress | Subnet address for hosting NGF instances in zone B. |
| Public Subnet in Zone A | PublicSubnetAAddress | Subnet address for hosting load balancer internal IPs in zone A. |
| Public Subnet in Zone B | PublicSubnetBAddress | Subnet address for hosting load balancer internal IPs in zone B. |
| SSLCertificateId | SSLCertificateId | ARN of certificate hosted in ACM to be used for SSLVPN. |


## Launching the template
For instructions on how to launch a CloudFormation Template, consult AWS documentation or check [How to Deploy an F-Series Firewall in AWS via CloudFormation Template](https://campus.barracuda.com/product/nextgenfirewallf/article/NGF71/AWSDeployCloudFormationTemplate/) article in Barracuda Campus.

## Additional Documentation
[Implementation Guide - NextGen Firewall in AWS](https://campus.barracuda.com/product/nextgenfirewallf/article/NGF71/IGAWS/)
[AWS Reference Architecture - NextGen Firewall Auto Scaling Cluster](https://campus.barracuda.com/product/nextgenfirewallf/article/NGF71/IGAWSRefAutoScaling/)
