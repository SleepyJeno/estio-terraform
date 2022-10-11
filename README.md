# estio-terraform
## Module structure
The key infrastructure is split up into 3 main modules:
* `security groups` for ACL setup
* `subnets` for main networking setup
* `instances` for EC2 and RDS DB instance setup
* `flask_db_app_instances` for alternative way of setting up the instances (EC2 and RDS) using `null_resource`

The said modules are then called from the root folder's `main.tf`

## What's inside
The provisioned infrastructure will provide you with the following resources:
```
1 VPC
3 subnets (1 public and 2 private)
1 subnet group spanning over 2 AZs
2 route tables - one for public and one for private subnets
2 security groups providing access to EC2 and RDS instances
1 RDS DB instance (MySQL)
1 EC2 instance with pre-installed docker, MySQL client, and Python 3
```
The EC2 instance will run a basic Flask application that lets the user add and review movies, and this will be persisted into the database.

## How-to:
1) In the root folder create `terraform.tfvars` with your AWS credentials in the following format:
```
aws_access_key="accesskey"
aws_secret_key="secretkey"
```
2) Run `terraform init` to download and install module dependencies 
3) Run `terraform apply` to provision the resources
