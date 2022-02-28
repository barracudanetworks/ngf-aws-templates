# Auto Scaling Group - Barracuda CloudGen Firewall Template for AWS

## Introduction
This solution deploys to AWS EC2 an auto scaling group of Barracuda CloudGen Firewalls (CGF). Firewall instances are synchronized and deployed behind an Elastic Load Balancer, which makes them visible and acting as a single system. The ASG is by default automatically scaled out/in based on number of concurrent VPN connections.

![ASG architecture diagram](https://campus.barracuda.com/resources/attachments/image/96025948/1/aws_autoscale_cluster_plain-01.png)

## Prerequisites

Before attempting to deploy the solution you must create an IAM Role for Barracuda CloudGen Firewalls. See [How to Create an IAM Role for an CloudGen Firewall in AWS](https://campus.barracuda.com/product/nextgenfirewallf/article/NGF71/AWSCreateIAMRoleFW/) for details.

Solution does not check for availability of requested instance types in a given region. Please consult AWS documentation for instance type availability. Barracuda recommends use of **m5** or **c5** series for production and **t3** for small workloads or development. Using instance type unavailable in the region will result in ASG not meeting the required initial size and thus failing CloudFormation deployment.

If you plan to use SSLVPN functionality in CGF, you need to provide the solution with ARN of your SSL certificate hosted in AWS Certificate Manager. For details on how to how to use ACM see [Working with Server Certificates](http://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_server-certs.html) in AWS documentation.

## Deployed Resources

Following resources will be created by the template:
- One VPC with public and private subnets in 2 Availability Zones
- Two Elastic Load Balancers for management and production traffic
- S3 bucket used for configuration and updates synchronization
- Auto Scaling Group with proper Launch Configuration and Scaling Policies
- additional helper elements: routes, Internet Gateway, NAT Gateways, SNS topic and SQS queues.

## Template Parameters

| CFT Label | Parameter Name |  Description |
|---------------|------------|---------------------|
| Minimum Size | InitialSize | Minimum (and initial) size of ASG. |
| Maximum Size | MaxSize | Maximum size the ASG is allowed to reach. |
| Scale-out Trigger | HighThreshold | Maximum average VPN clients per instance triggering scaling out of ASG. |
| Scale-in Trigger | LowThreshold | Minimum average VPN clients per instance triggering scaling in of ASG. |
| Instance Type | InstanceType | Instance type to use for CGF instances. Please choose one available in your region. |
| IAM Profile | IAMProfile | IAM profile to be assigned to instances. |
| VPC Address | VpcAddress | IP address space for newly created VPC. |
| Private Subnet in Zone A | PrivateSubnetAAddress | Subnet address for hosting CGF instances in zone A. |
| Private Subnet in Zone B | PrivateSubnetBAddress | Subnet address for hosting CGF instances in zone B. |
| Public Subnet in Zone A | PublicSubnetAAddress | Subnet address for hosting load balancer internal IPs in zone A. |
| Public Subnet in Zone B | PublicSubnetBAddress | Subnet address for hosting load balancer internal IPs in zone B. |
| SSLCertificateId | SSLCertificateId | ARN of certificate hosted in ACM to be used for SSLVPN. |


## Launching the template
For instructions on how to launch a CloudFormation Template, consult AWS documentation or check [How to Deploy an CloudGen Firewall in AWS via CloudFormation Template](https://campus.barracuda.com/product/cloudgenfirewall/doc/95259228/how-to-deploy-a-cloudgen-in-aws-via-cloudformation-template) article in Barracuda Campus.

## Additional Documentation
[Implementation Guide - CloudGen Firewall in AWS](https://campus.barracuda.com/product/cloudgenfirewall/doc/96025944/implementation-guide-cloudgen-firewall-in-aws)
[AWS Reference Architecture - CloudGen Firewall Auto Scaling Cluster](https://campus.barracuda.com/product/cloudgenfirewall/doc/96025948/aws-reference-architecture-cloudgen-firewall-auto-scaling-cluster)
