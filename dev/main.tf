provider "aws" {
    region = "ap-southeast-1"
}

# VPC
resource "aws_vpc" "dimo-solar-vpc-test-apse1" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = true
    enable_dns_support   = true

    tags = {
        Name = "${var.project_name}-vpc-${var.env}-${var.region_suffix}"
        env = var.env
        terraform = var.terraform
        project = var.project
        owner = var.owner
    }
}

# Private subnets
# Subnet for apse1a-private1
resource "aws_subnet" "dimo-solar-private1-subnet-apse1a" {
    vpc_id            = aws_vpc.dimo-solar-vpc-test-apse1.id
    cidr_block       = "${var.apse1a_private1_subnet_cidr}"
    availability_zone = "ap-southeast-1a"

    tags = {
        Name = "${var.project_name}-private1-subnet-${var.env}-apse1a"
        env = var.env
        terraform = var.terraform
        project = var.project
        owner = var.owner
    }
}

# Subnet for apse1b-private2
resource "aws_subnet" "dimo-solar-private2-subnet-apse1b" {
    vpc_id            = aws_vpc.dimo-solar-vpc-test-apse1.id
    cidr_block       = "${var.apse1b_private2_subnet_cidr}"
    availability_zone = "ap-southeast-1b"

    tags = {
        Name = "${var.project_name}-private2-subnet-${var.env}-apse1b"
        env = var.env
        terraform = var.terraform
        project = var.project
        owner = var.owner
    }
}

# Public subnets
# Subnet for apse1a-public1
resource "aws_subnet" "dimo-solar-public1-subnet-apse1a" {
    vpc_id            = aws_vpc.dimo-solar-vpc-test-apse1.id
    cidr_block       = "${var.apse1a_public1_subnet_cidr}"
    availability_zone = "ap-southeast-1a"

    tags = {
        Name = "${var.project_name}-public1-subnet-${var.env}-apse1a"
        env = var.env
        terraform = var.terraform
        project = var.project
        owner = var.owner
    }
}

# Subnet for apse1b-public2
resource "aws_subnet" "dimo-solar-public2-subnet-apse1b" {
    vpc_id            = aws_vpc.dimo-solar-vpc-test-apse1.id
    cidr_block       = "${var.apse1b_public2_subnet_cidr}"
    availability_zone = "ap-southeast-1b"

    tags = {
        Name = "${var.project_name}-public2-subnet-${var.env}-apse1b"
        env = var.env
        terraform = var.terraform
        project = var.project
        owner = var.owner
    }
}

#Private Subnet group for RDS
resource "aws_db_subnet_group" "dimo-solar-rds-subnet-group-test-apse1" {
    name       = "${var.project_name}-private-subnet-group-${var.env}-${var.region_suffix}"
    subnet_ids = [aws_subnet.dimo-solar-private1-subnet-apse1a.id, aws_subnet.dimo-solar-private2-subnet-apse1b.id]

    tags = {
        Name = "${var.project_name}-private-subnet-group-${var.env}-${var.region_suffix}"
        env = var.env
        terraform = var.terraform
        project = var.project
        owner = var.owner
    }
}

# Internet Gateway
resource "aws_internet_gateway" "dimo-solar-igw-test-apse1" {
    vpc_id = aws_vpc.dimo-solar-vpc-test-apse1.id

    tags = {
        Name = "${var.project_name}-igw-${var.env}-${var.region_suffix}"
        env = var.env
        terraform = var.terraform
        project = var.project
        owner = var.owner
    }
}

# VPC Endpoint for S3
resource "aws_vpc_endpoint" "dimo-solar-s3-vpce" {
  vpc_id           = aws_vpc.dimo-solar-vpc-test-apse1.id
  service_name     = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = [
    aws_route_table.dimo-solar-rtb-private1-apse1a.id,
    aws_route_table.dimo-solar-rtb-private2-apse1b.id
  ]

  tags = {
    Name = "${var.project_name}-vpce-s3-${var.env}-${var.region_suffix}"
    env  = var.env
    terraform = var.terraform
    project = var.project
    owner = var.owner
  }
}

#VPC Endpoint for Secrets Manager
resource "aws_vpc_endpoint" "dimo-solar-secretsmanager-vpce-staging-apse1" {
  vpc_id              = aws_vpc.dimo-solar-vpc-test-apse1.id
  service_name        = "com.amazonaws.${var.aws_region}.secretsmanager"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.dimo-solar-private1-subnet-apse1a.id, aws_subnet.dimo-solar-private2-subnet-apse1b.id]
  security_group_ids  = [aws_security_group.dimo-solar-vpce-sg-test-apse1.id]
  private_dns_enabled = true

  tags = {
    Name      = "${var.project_name}-vpce-secretsmanager-${var.env}-${var.region_suffix}"
    env       = var.env
    terraform = var.terraform
    project   = var.project
    owner     = var.owner
  }
}

# Elastic IP for NAT Gateway
resource "aws_eip" "dimo-solar-nat-eip-test-apse1" {
  domain = "vpc"

  tags = {
    Name      = "${var.project_name}-nat-eip-${var.env}-${var.region_suffix}"
    env       = var.env
    terraform = var.terraform
    project   = var.project
    owner     = var.owner
  }
}

# NAT Gateway for private subnet outbound internet access
resource "aws_nat_gateway" "dimo-solar-nat-gw-test-apse1" {
  allocation_id = aws_eip.dimo-solar-nat-eip-test-apse1.id
  subnet_id     = aws_subnet.dimo-solar-public1-subnet-apse1a.id

  tags = {
    Name      = "${var.project_name}-nat-gw-${var.env}-${var.region_suffix}"
    env       = var.env
    terraform = var.terraform
    project   = var.project
    owner     = var.owner
  }

  depends_on = [aws_internet_gateway.dimo-solar-igw-test-apse1]
}

# Route Table for Public Subnets
resource "aws_route_table" "dimo-solar-rtb-public-test-apse1" {
    vpc_id = aws_vpc.dimo-solar-vpc-test-apse1.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.dimo-solar-igw-test-apse1.id
    }

    tags = {
        Name = "${var.project_name}-rtb-public-${var.env}-${var.region_suffix}"
        env = var.env
        terraform = var.terraform
        project = var.project
        owner = var.owner
    }
}

# Public Subnets Association
resource "aws_route_table_association" "dimo-solar-public-rtb-assoc" {
  for_each = {
    public1 = aws_subnet.dimo-solar-public1-subnet-apse1a.id
    public2 = aws_subnet.dimo-solar-public2-subnet-apse1b.id
  }

  subnet_id      = each.value
  route_table_id = aws_route_table.dimo-solar-rtb-public-test-apse1.id
}

# Route Table for Private1 Subnet with S3 VPC Endpoint
resource "aws_route_table" "dimo-solar-rtb-private1-apse1a" {
  vpc_id = aws_vpc.dimo-solar-vpc-test-apse1.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.dimo-solar-nat-gw-test-apse1.id
  }

  tags = {
    Name = "${var.project_name}-rtb-private1-${var.env}-apse1a"
    env  = var.env
    terraform = var.terraform
  }
}

resource "aws_route_table_association" "dimo-solar-private1-rtb-assoc" {
  subnet_id      = aws_subnet.dimo-solar-private1-subnet-apse1a.id
  route_table_id = aws_route_table.dimo-solar-rtb-private1-apse1a.id
}

# Route Table for Private2 Subnet with S3 VPC Endpoint
resource "aws_route_table" "dimo-solar-rtb-private2-apse1b" {
  vpc_id = aws_vpc.dimo-solar-vpc-test-apse1.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.dimo-solar-nat-gw-test-apse1.id
  }

  tags = {
    Name = "${var.project_name}-rtb-private2-${var.env}-apse1b"
    env  = var.env
    terraform = var.terraform
  }
}

resource "aws_route_table_association" "dimo-solar-private2-rtb-assoc" {
  subnet_id      = aws_subnet.dimo-solar-private2-subnet-apse1b.id
  route_table_id = aws_route_table.dimo-solar-rtb-private2-apse1b.id
}

#Create AWS Instance
resource "aws_instance" "dimo-solar-ec2-test-apse1" {
  ami           = var.ec2_ami

  instance_type = var.ec2_instance_type

  subnet_id = aws_subnet.dimo-solar-private1-subnet-apse1a.id

  iam_instance_profile = var.iam_instance_profile

  vpc_security_group_ids = [aws_security_group.dimo-solar-ec2-sg-test-apse1.id]

  #install aws cli
  user_data = <<-EOF
                #!/bin/bash
                set -euxo pipefail

                ########################################
                # Update & install dependencies
                ########################################
                apt-get update -y
                apt-get install -y unzip curl ca-certificates gnupg

                ########################################
                # Install AWS CLI v2
                ########################################
                ARCH=$(uname -m)
                if [ "$ARCH" = "aarch64" ]; then
                  AWS_URL="https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip"
                else
                  AWS_URL="https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"
                fi

                curl -fsSL "$AWS_URL" -o /tmp/awscliv2.zip
                unzip -o /tmp/awscliv2.zip -d /tmp/awscli
                /tmp/awscli/aws/install --update
                rm -rf /tmp/awscliv2.zip /tmp/awscli

                ########################################
                # Install Node.js 24
                ########################################
                curl -fsSL https://deb.nodesource.com/setup_24.x | bash -
                apt-get install -y nodejs

                ########################################
                # Verify installations
                ########################################
                echo "=== Verifying installations ==="
                aws --version
                node -v
                npm -v
                echo "=== Setup complete ==="
                EOF

  volume_tags = {
    Name = "${var.project_name}-ec2-volume-${var.env}-${var.region_suffix}"
    env = var.env
    terraform = var.terraform
    volume_type = "gp3"
    volume_size = "20"
  }

  tags = {
    Name = "${var.project_name}-ec2-${var.env}-${var.region_suffix}"
    env = var.env
    terraform = var.terraform
    owner = var.owner
    project = var.project
  }
}

#Target Group for ALB
resource "aws_lb_target_group" "dimo-solar-alb-tg-test-apse1" {
    name     = "${var.project_name}-alb-tg-${var.env}-${var.region_suffix}"
    port     = 80
    protocol = "HTTP"
    vpc_id   = aws_vpc.dimo-solar-vpc-test-apse1.id
    target_type = "instance"

    health_check {
        path                = "/health"
        protocol            = "HTTP"
        matcher             = "200-399"
        interval            = 30
        timeout             = 5
        healthy_threshold   = 5
        unhealthy_threshold = 2
    }

    tags = {
        Name = "${var.project_name}-alb-tg-${var.env}-${var.region_suffix}"
        env = var.env
        terraform = var.terraform
        owner = var.owner
        project = var.project
    }
}

#Listener for ALB
resource "aws_lb_listener" "dimo-solar-alb-listener-test-apse1" {
    load_balancer_arn = aws_lb.dimo-solar-alb-test-apse1.arn
    port              = "80"
    protocol          = "HTTP"

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.dimo-solar-alb-tg-test-apse1.arn
    }
}

#Target Group Attachment for ALB
resource "aws_lb_target_group_attachment" "dimo-solar-alb-tg-attachment-test-apse1" {
    target_group_arn = aws_lb_target_group.dimo-solar-alb-tg-test-apse1.arn
    target_id        = aws_instance.dimo-solar-ec2-test-apse1.id
    port             = 3000
}

#Create Application Load Balancer
resource "aws_lb" "dimo-solar-alb-test-apse1" {
    name               = "${var.project_name}-alb-${var.env}-${var.region_suffix}"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [aws_security_group.dimo-solar-alb-sg-test-apse1.id]
    subnets            = [aws_subnet.dimo-solar-public1-subnet-apse1a.id, aws_subnet.dimo-solar-public2-subnet-apse1b.id]

    tags = {
        Name = "${var.project_name}-alb-${var.env}-${var.region_suffix}"
        env = var.env
        terraform = var.terraform
        owner = var.owner
        project = var.project
    }
}



#------------------------ Security Groups ------------------------

#Security Group for all VPC Enpoints 
resource "aws_security_group" "dimo-solar-vpce-sg-test-apse1" {
    vpc_id = aws_vpc.dimo-solar-vpc-test-apse1.id
    name = "${var.project_name}-vpce-sg-${var.env}-${var.region_suffix}"
    description = "Security group for VPC Endpoint to S3"
    
    tags = {
        Name = "${var.project_name}-vpce-sg-${var.env}-${var.region_suffix}"
        env = var.env
        terraform = var.terraform
        owner = var.owner
        project = var.project
    }
}

#Security Group for EC2
resource "aws_security_group" "dimo-solar-ec2-sg-test-apse1" {
    vpc_id = aws_vpc.dimo-solar-vpc-test-apse1.id
    name = "${var.project_name}-ec2-sg-${var.env}-${var.region_suffix}"
    description = "Security group for EC2 instances"
    
    tags = {
        Name = "${var.project_name}-ec2-sg-${var.env}-${var.region_suffix}"
        env = var.env
        terraform = var.terraform
        owner = var.owner
        project = var.project
    }
}

#Security Group for RDS
resource "aws_security_group" "dimo-solar-rds-sg-test-apse1" {
    vpc_id = aws_vpc.dimo-solar-vpc-test-apse1.id
    name = "${var.project_name}-rds-sg-${var.env}-${var.region_suffix}"
    description = "Security group for RDS instances"

    tags = {
        Name = "${var.project_name}-rds-sg-${var.env}-${var.region_suffix}"
        env = var.env
        terraform = var.terraform
        owner = var.owner
        project = var.project
    }
}

#Security Group for ALB
resource "aws_security_group" "dimo-solar-alb-sg-test-apse1" {
    vpc_id = aws_vpc.dimo-solar-vpc-test-apse1.id
    name = "${var.project_name}-alb-sg-${var.env}-${var.region_suffix}"
    description = "Security group for ALB"

    tags = {
        Name = "${var.project_name}-alb-sg-${var.env}-${var.region_suffix}"
        env = var.env
        terraform = var.terraform
        owner = var.owner
        project = var.project
    }
}

#Security Group for Lambda
resource "aws_security_group" "dimo-solar-lambda-sg-test-apse1" {
    vpc_id = aws_vpc.dimo-solar-vpc-test-apse1.id
    name = "${var.project_name}-lambda-sg-${var.env}-${var.region_suffix}"
    description = "Security group for Lambda functions"

    tags = {
        Name = "${var.project_name}-lambda-sg-${var.env}-${var.region_suffix}"
        env = var.env
        terraform = var.terraform
        owner = var.owner
        project = var.project
    }
}

#------------------------ End of Security Groups ------------------------



#------------------------ All Egress Rules ------------------------

#Egress rule to allow all traffic to all ports
resource "aws_vpc_security_group_egress_rule" "allow-all-to-all-ports" {
    for_each = {
      ec2 = aws_security_group.dimo-solar-ec2-sg-test-apse1.id
      rds = aws_security_group.dimo-solar-rds-sg-test-apse1.id
      alb = aws_security_group.dimo-solar-alb-sg-test-apse1.id
      vpce = aws_security_group.dimo-solar-vpce-sg-test-apse1.id
    }

    security_group_id = each.value
    ip_protocol       = "-1"
    cidr_ipv4         = "0.0.0.0/0"
}

#Egress rule to allow all traffic to 5432 port toRDS
resource "aws_vpc_security_group_egress_rule" "allow-tcp-to-5432-port" {
    for_each = {
      ec2 = aws_security_group.dimo-solar-ec2-sg-test-apse1.id
      lambda = aws_security_group.dimo-solar-lambda-sg-test-apse1.id
    }

    security_group_id = each.value
    ip_protocol       = "tcp"
    from_port         = 5432
    to_port           = 5432
    referenced_security_group_id = aws_security_group.dimo-solar-rds-sg-test-apse1.id
}

# Egress rule to allow all TCP traffic from port 443 from lambda to Endpoint SGs 
resource "aws_vpc_security_group_egress_rule" "allow-tcp-to-443-port-from-lambda-and-endpoint" {
    security_group_id = aws_security_group.dimo-solar-lambda-sg-test-apse1.id
    ip_protocol       = "tcp"
    from_port         = 443
    to_port           = 443 
    referenced_security_group_id = aws_security_group.dimo-solar-vpce-sg-test-apse1.id
}

#Egress rule to allow all TCP traffic from port 443 from lambda to s3 endpoint prefix list
resource "aws_vpc_security_group_egress_rule" "allow-tcp-to-443-port-from-lambda-to-s3-pl" {
    security_group_id = aws_security_group.dimo-solar-lambda-sg-test-apse1.id
    ip_protocol       = "tcp"
    from_port         = 443
    to_port           = 443 
    prefix_list_id = aws_vpc_endpoint.dimo-solar-s3-vpce.prefix_list_id
}

#--------------------End of Egress Rules ---------------------



#------------------- All Ingress Rules ------------------------

# Ingress rule to allow all TCP traffic from port 443
resource "aws_vpc_security_group_ingress_rule" "allow-all-tcp-from-443" {
    for_each = {
      ec2    = aws_security_group.dimo-solar-ec2-sg-test-apse1.id
      lambda = aws_security_group.dimo-solar-lambda-sg-test-apse1.id
    }

    security_group_id = aws_security_group.dimo-solar-vpce-sg-test-apse1.id
    ip_protocol       = "tcp"
    description = "Allow TCP traffic from port 443 S3, Type Https"
    from_port         = 443
    to_port           = 443 
    referenced_security_group_id =  each.value
} 

# Ingress rule to allow TCP traffic from port 5432 from Internet
resource "aws_vpc_security_group_ingress_rule" "allow-all-tcp-from-5432" {
    security_group_id = aws_security_group.dimo-solar-ec2-sg-test-apse1.id
    ip_protocol       = "tcp"
    description = "Allow TCP traffic from port 5432 PostgreSQL"
    from_port         = 5432
    to_port           = 5432 
    cidr_ipv4 =  "0.0.0.0/0"
}

# Ingress rule to allow TCP traffic from port 5432 from EC2 to RDS
resource "aws_vpc_security_group_ingress_rule" "allow-tcp-from-5432" {
    for_each = {
      ec2    = aws_security_group.dimo-solar-ec2-sg-test-apse1.id
      lambda = aws_security_group.dimo-solar-lambda-sg-test-apse1.id
    }

    security_group_id = aws_security_group.dimo-solar-rds-sg-test-apse1.id
    ip_protocol       = "tcp"
    description = "Allow TCP traffic from port 5432 PostgreSQL"
    from_port         = 5432
    to_port           = 5432 
    referenced_security_group_id = each.value
}

# Ingress rule to allow TCP traffic to port 3000
resource "aws_vpc_security_group_ingress_rule" "allow-tcp-to-3000" {
    security_group_id = aws_security_group.dimo-solar-ec2-sg-test-apse1.id
    ip_protocol       = "tcp"
    description = "Allow TCP traffic to port 3000 Grafana"
    from_port         = 3000
    to_port           = 3000 
    referenced_security_group_id = aws_security_group.dimo-solar-alb-sg-test-apse1.id
}

# Ingress rule to allow TCP traffic to port 80 from ALB to Ec2
resource "aws_vpc_security_group_ingress_rule" "allow-tcp-from-80" {
    security_group_id = aws_security_group.dimo-solar-ec2-sg-test-apse1.id
    ip_protocol       = "tcp"
    description = "Allow TCP traffic to port 80 HTTP"
    from_port         = 80
    to_port           = 80 
    referenced_security_group_id = aws_security_group.dimo-solar-alb-sg-test-apse1.id
}

# Ingress rule to allow HTTP from anywhere
resource "aws_vpc_security_group_ingress_rule" "allow-http-from-anywhere" {
    security_group_id = aws_security_group.dimo-solar-alb-sg-test-apse1.id
    ip_protocol       = "tcp"
    description = "Allow HTTP traffic from anywhere"
    from_port         = 80
    to_port           = 80 
    cidr_ipv4         = "0.0.0.0/0"
}

#----------------------End of Ingress Rules ---------------------

#---------------------- S3 Bucket ---------------------

# New S3 bucket for dev environment.
# Add/adjust policy, lifecycle, CORS, logging, notifications to match source bucket if needed.
resource "aws_s3_bucket" "dimo-solar-s3-bucket-dev-apse1" {
  bucket = "dimo-solar-s3-bucket-dev-apse1"

  tags = {
    Name      = "dimo-solar-s3-bucket-dev-apse1"
    env       = var.env
    terraform = var.terraform
    owner     = var.owner
    project   = var.project
  }
}

resource "aws_s3_bucket_versioning" "dimo-solar-s3-bucket-dev-apse1-versioning" {
  bucket = aws_s3_bucket.dimo-solar-s3-bucket-dev-apse1.id

  versioning_configuration {
    status = "Enabled"
  }
}

#object ownership acl disabled and bucket owner enforced enabled to ensure bucket owner has full control over objects uploaded by other accounts
resource "aws_s3_bucket_ownership_controls" "dimo-solar-s3-bucket-dev-apse1-ownership-controls" {
  bucket = aws_s3_bucket.dimo-solar-s3-bucket-dev-apse1.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "dimo-solar-s3-bucket-dev-apse1-sse" {
  bucket = aws_s3_bucket.dimo-solar-s3-bucket-dev-apse1.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "dimo-solar-s3-bucket-dev-apse1-pab" {
  bucket = aws_s3_bucket.dimo-solar-s3-bucket-dev-apse1.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

locals {
  s3_upload_source_dir_abs = "${path.module}/${var.s3_upload_source_dir}"
  s3_upload_files          = try(fileset(local.s3_upload_source_dir_abs, "**"), [])
}

resource "aws_s3_object" "dimo-solar-s3-bucket-dev-apse1-folder-upload" {
  for_each = { for file in local.s3_upload_files : file => file }

  bucket = aws_s3_bucket.dimo-solar-s3-bucket-dev-apse1.id
  key    = var.s3_upload_prefix == "" ? each.value : "${trim(var.s3_upload_prefix, "/")}/${each.value}"
  source = "${local.s3_upload_source_dir_abs}/${each.value}"
  etag   = filemd5("${local.s3_upload_source_dir_abs}/${each.value}")
}
#-------------------- End of S3 Bucket ----------------

#-------------------- IoT Rule to trigger Lambda ----------------
resource "aws_iot_topic_rule" "solar_livedata_rule" {
  name        = "Solar_livedata_rule"
  enabled     = true
  sql         = "SELECT * FROM 'dsmpdata' WHERE (isUndefined(ws) = false OR isUndefined(lgr) = false OR isUndefined(inv) = false OR isUndefined(mbr) = false OR isUndefined(lv) = false OR isUndefined(mv) = false OR isUndefined(ed) = false OR isUndefined(pr) = false OR isUndefined(sts) = false)"
  sql_version = "2016-03-23"
  description = "Triggers on shadow updates and invokes Lambda"

  lambda {
    function_arn = "arn:aws:lambda:ap-southeast-1:290188041046:function:dimo-solar-lambda-dev-apse1"
  }

  lambda {
    function_arn = "arn:aws:lambda:ap-southeast-1:290188041046:function:dimo-solar-lambda-temp-staging-apse1"
  }

  lambda {
    function_arn = "arn:aws:lambda:ap-southeast-1:835661413932:function:dimo-solar-lambda-staging-apse1"
  }

  lambda {
    function_arn = "arn:aws:lambda:ap-southeast-1:130871338638:function:dimo-solar-lambda-prod-apse1"
  }

  lambda {
    function_arn = "arn:aws:lambda:ap-southeast-1:901524151938:function:dimo-solar-lambda-test-apse1"
  }

  tags = {
    "owner" = "digital-projects"
  }
}

resource "aws_iot_topic_rule" "solar_test_rule" {
  name        = "solar_test_rule"
  enabled     = true
  sql         = "SELECT * FROM 'dsmptest' WHERE (isUndefined(ws) = false OR isUndefined(lgr) = false OR isUndefined(inv) = false OR isUndefined(mbr) = false OR isUndefined(lv) = false OR isUndefined(mv) = false OR isUndefined(ed) = false OR isUndefined(pr) = false OR isUndefined(sts) = false)"
  sql_version = "2016-03-23"
  description = "Triggers on shadow updates and invokes Lambda"

  lambda {
    function_arn = "arn:aws:lambda:ap-southeast-1:290188041046:function:dimo-solar-lambda-dev-apse1"
  }

  lambda {
    function_arn = "arn:aws:lambda:ap-southeast-1:290188041046:function:dimo-solar-lambda-temp-staging-apse1"
  }

  lambda {
    function_arn = "arn:aws:lambda:ap-southeast-1:835661413932:function:dimo-solar-lambda-staging-apse1"
  }

  lambda {
    function_arn = "arn:aws:lambda:ap-southeast-1:130871338638:function:dimo-solar-lambda-prod-apse1"
  }

  lambda {
    function_arn = "arn:aws:lambda:ap-southeast-1:901524151938:function:dimo-solar-lambda-test-apse1"
  }

  tags = {
    "owner" = "digital-transformation"
  }
}