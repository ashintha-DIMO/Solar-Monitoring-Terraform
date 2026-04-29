variable "project_name" {
  description = "Project name prefix"
  type        = string
  default     = "dimo-solar"
}

variable "env" {
  description = "Environment (dev, test, uat, prod)"
  type        = string
  default     = "test"
}

variable "owner" {
  description = "Owner of the project"
  type        = string
  default     = "digital-projects"
}

variable "project" {
  description = "Project name"
  type        = string
  default     = "solar-monitoring"
}

variable "terraform" {
  description = "Whether it used Terraform"
  type        = string
  default     = "yes"
}

variable "region_suffix" {
  description = "Region suffix used in naming"
  type        = string
  default     = "apse1"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

# Networking
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "apse1a_private1_subnet_cidr" {
  description = "CIDR block for Subnet"
  type        = string
  default     = "10.0.128.0/20"
}

variable "apse1b_private2_subnet_cidr" {
  description = "CIDR block for Subnet"
  type        = string
  default     = "10.0.144.0/20"
}

variable "apse1a_public1_subnet_cidr" {
  description = "CIDR block for Subnet"
  type        = string
  default     = "10.0.0.0/20"
}

variable "apse1b_public2_subnet_cidr" {
  description = "CIDR block for Subnet"
  type        = string
  default     = "10.0.16.0/20"
}

# Security Group
variable "ssh_cidr_ipv4" {
  description = "Allowed IPv4 CIDR for SSH"
  type        = string
  default     = "0.0.0.0/0"
}

variable "ssh_cidr_ipv6" {
  description = "Allowed IPv6 CIDR for SSH"
  type        = string
  default     = "::/0"
}

# EC2 Instance variables
variable "ec2_ami" {
  description = "AMI ID for EC2 instance"
  type        = string
  default     = "ami-02c7683e4ca3ebf58"
}

variable "ec2_instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.large"
}

variable "iam_instance_profile" {
  description = "iam profile for SSM"
  type        = string
  default     = "SolarMonitoring-EC2-SSM"
}

# S3 upload automation (local folder -> destination S3 bucket)
variable "s3_upload_source_dir" {
  description = "Local folder (relative to this Terraform module) to upload into S3"
  type        = string
  default     = "s3_upload"
}

variable "s3_upload_prefix" {
  description = "Optional key prefix inside the S3 bucket for uploaded files"
  type        = string
  default     = ""
}
