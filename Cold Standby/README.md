# Cold Standby - Barracuda NextGen Firewall template for AWS

## Introduction
This template deploys a reference architecture functionally equivalent to cold standby in physical world and sometiems referred to as AutoScaling Group of One. It uses AWS AutoScaling Group to replace an broken instance of NextGen Firewall by a new one inheriting existing configuration. New instance, after provisioning the last known configuration, claims existing routes and Elastic IP effectively replacing the broken instance in the network.

## Prerequisites
Before attempting to deploy the solution you must create an IAM Role for Barracuda NextGen Firewalls. See [How to Create an IAM Role for an F-Series Firewall in AWS](https://campus.barracuda.com/product/nextgenfirewallf/article/NGF71/AWSCreateIAMRoleFW/) for details.

Solution does not check for availability of requested instance types in a given region. Please consult AWS documentation for instance type availability. Barracuda recommends use of **m4** or **c4** series. Using unavailable instance type will result in ASG not meeting the required initial size and thus failing CloudFormation deployment.

## Deployed resources

Following resources will be deployed by this template:
 - One VPC with 2 public subnets in 2 different AZs for hosting NGF instances
 - routing table for NGFs
 - routing table for private networks with default route via NGF
 - S3 bucket for storing Configuration
 - SNS and SQS resources for ASG (not used in this particular architecture)
 - One Elastic IP
 - Launch Configuration and ASG

The template does **NOT** create a backend private subnet for hosting resources. Create it manually and associate with "route-via-NGF" route table.

## Launching the template
For instructions on how to launch a CloudFormation Template, consult AWS documentation or check [How to Deploy an F-Series Firewall in AWS via CloudFormation Template](https://campus.barracuda.com/product/nextgenfirewallf/article/NGF71/AWSDeployCloudFormationTemplate/) article in Barracuda Campus.

Note: when terminating the stack, perform the following manually:
- remove scale-in protection from the instance in ASG
- empty the S3 bucket

## Additional Documentation
[Implementation Guide - NextGen Firewall in AWS](https://campus.barracuda.com/product/nextgenfirewallf/article/NGF71/IGAWS/)
[AWS Reference Architecture - NextGen Firewall Cold Standby Cluster](https://campus.barracuda.com/product/nextgenfirewallf/doc/70584745/aws-reference-architecture-nextgen-firewall-cold-standby-cluster/)
