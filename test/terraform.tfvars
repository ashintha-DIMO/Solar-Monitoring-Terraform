# Project Settings
project_name = "dimo-solar"
env          = "test"
region_suffix = "apse1"
aws_region   = "ap-southeast-1"
terraform    = "yes"
owner        = "digital-transformation"
project      = "solar-monitoring"

# VPC
vpc_cidr = "10.1.0.0/16"

# Subnets
apse1a_private1_subnet_cidr = "10.1.11.0/24"
apse1b_private2_subnet_cidr = "10.1.12.0/24"

apse1a_public1_subnet_cidr  = "10.1.1.0/24"
apse1b_public2_subnet_cidr  = "10.1.2.0/24"

# EC2 Settings
ec2_ami            = "ami-02c7683e4ca3ebf58"
ec2_instance_type  = "t3.large"
iam_instance_profile = "SolarMonitoring-EC2-SSM"

# S3 Upload (local folder -> destination bucket)
s3_upload_source_dir = "../s3_upload"
s3_upload_prefix     = ""

