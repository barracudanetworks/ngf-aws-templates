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
