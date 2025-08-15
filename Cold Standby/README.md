# Cold Standby - Barracuda CloudGen Firewall template for AWS

## Introduction
This template deploys a reference architecture functionally equivalent to cold standby in physical world and sometiems referred to as AutoScaling Group of One. It uses AWS AutoScaling Group to replace an broken instance of CloudGen Firewall by a new one inheriting existing configuration. New instance, after provisioning the last known configuration, claims existing routes and Elastic IP effectively replacing the broken instance in the network.

## Prerequisites
Before attempting to deploy the solution you must create an IAM Role for Barracuda CloudGen Firewalls. See [How to Create an IAM Role for an CloudGen Firewall in AWS](https://campus.barracuda.com/doc/170821273/) for details.

Solution does not check for availability of requested instance types in a given region. Please consult AWS documentation for instance type availability. Barracuda recommends use of **m4** or **c4** series. Using unavailable instance type will result in ASG not meeting the required initial size and thus failing CloudFormation deployment.

## Available templates

* [*PAYG-new-VPC](NGF_Coldstandby-PAYG-new-VPC.md) - deploy together with a new VPC
* [*PAYG-existing-VPC](NGF_Coldstandby-PAYG-existing-VPC.md) - deploy into existing VPC

## Launching the template
For instructions on how to launch a CloudFormation Template, consult AWS documentation or check [How to Deploy an CloudGen Firewall in AWS via CloudFormation Template](https://campus.barracuda.com/doc/170821027/) article in Barracuda Campus.

Note: when terminating the stack, perform the following manually:
- remove scale-in protection from the instance in ASG
- empty the S3 bucket

## Additional Documentation
* [Implementation Guide - CloudGen Firewall in AWS](https://campus.barracuda.com/doc/170819697/)
* [AWS Reference Architecture - CloudGen Firewall Cold Standby Cluster](https://campus.barracuda.com/doc/170819707/)
