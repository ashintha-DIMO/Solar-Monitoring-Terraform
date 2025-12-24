provider "aws" {
    region = "ap-southeast-1"
}

# VPC
resource "aws_vpc" "dimo-solar-vpc-test-apse1" {
    cidr_block = "${var.vpc_cidr}"

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

  tags = {
    Name = "${var.project_name}-vpce-s3-${var.env}-${var.region_suffix}"
    env  = var.env
    terraform = var.terraform
    project = var.project
    owner = var.owner
  }
}

#VPC Endpoint for SSM
resource "aws_vpc_endpoint" "dimo-solar-ssm-vpce" {
  vpc_id           = aws_vpc.dimo-solar-vpc-test-apse1.id
  service_name     = "com.amazonaws.${var.aws_region}.ssm"
  vpc_endpoint_type = "Interface"
  subnet_ids       = [aws_subnet.dimo-solar-private1-subnet-apse1a.id, aws_subnet.dimo-solar-private2-subnet-apse1b.id]
  security_group_ids = [aws_security_group.dimo-solar-vpce-s3-sg-test-apse1.id]

  tags = {
    Name = "${var.project_name}-vpce-ssm-${var.env}-${var.region_suffix}"
    env  = var.env
    terraform = var.terraform
    project = var.project
    owner = var.owner
  }
}

#VPC Endpoint for SSM Messages
resource "aws_vpc_endpoint" "dimo-solar-ssm-messages-vpce" {
  vpc_id           = aws_vpc.dimo-solar-vpc-test-apse1.id
  service_name     = "com.amazonaws.${var.aws_region}.ssmmessages"
  vpc_endpoint_type = "Interface"
  subnet_ids       = [aws_subnet.dimo-solar-private1-subnet-apse1a.id, aws_subnet.dimo-solar-private2-subnet-apse1b.id]
  security_group_ids = [aws_security_group.dimo-solar-vpce-s3-sg-test-apse1.id]

  tags = {
    Name = "${var.project_name}-vpce-ssm-messages-${var.env}-${var.region_suffix}"
    env  = var.env
    terraform = var.terraform
    project = var.project
    owner = var.owner
  }
}

#VPC Endpoint for EC2 Messages
resource "aws_vpc_endpoint" "dimo-solar-ec2-messages-vpce" {
  vpc_id           = aws_vpc.dimo-solar-vpc-test-apse1.id
  service_name     = "com.amazonaws.${var.aws_region}.ec2messages"
  vpc_endpoint_type = "Interface"
  subnet_ids       = [aws_subnet.dimo-solar-private1-subnet-apse1a.id, aws_subnet.dimo-solar-private2-subnet-apse1b.id]
  security_group_ids = [aws_security_group.dimo-solar-vpce-s3-sg-test-apse1.id]

  tags = {
    Name = "${var.project_name}-vpce-ec2-messages-${var.env}-${var.region_suffix}"
    env  = var.env
    terraform = var.terraform
    project = var.project
    owner = var.owner
  }
}

#VPC Endpoint for KMS
resource "aws_vpc_endpoint" "dimo-solar-kms-vpce" {
  vpc_id           = aws_vpc.dimo-solar-vpc-test-apse1.id
  service_name     = "com.amazonaws.${var.aws_region}.kms"
  vpc_endpoint_type = "Interface"
  subnet_ids       = [aws_subnet.dimo-solar-private1-subnet-apse1a.id, aws_subnet.dimo-solar-private2-subnet-apse1b.id]
  security_group_ids = [aws_security_group.dimo-solar-vpce-s3-sg-test-apse1.id]

  tags = {
    Name = "${var.project_name}-vpce-kms-${var.env}-${var.region_suffix}"
    env  = var.env
    terraform = var.terraform
    project = var.project
    owner = var.owner
  }
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

  # Local route
  route {
    cidr_block = var.vpc_cidr
    gateway_id = "local"
  }

  # S3 Prefix List route
  route {
    destination_prefix_list_id = aws_vpc_endpoint.dimo-solar-s3-vpce.prefix_list_id
    gateway_id     = "${aws_vpc_endpoint.dimo-solar-s3-vpce.id}"
  }

  # SSM Prefix List route
  route {
    destination_prefix_list_id = aws_vpc_endpoint.dimo-solar-ssm-vpce.prefix_list_id
  }

  # SSM Messages Prefix List route
  route {
    destination_prefix_list_id = aws_vpc_endpoint.dimo-solar-ssm-messages-vpce.prefix_list_id

  }

  # EC2 Messages Prefix List route
  route {
    destination_prefix_list_id = aws_vpc_endpoint.dimo-solar-ec2-messages-vpce.prefix_list_id
  }

  # KMS Prefix List route
  route {
    destination_prefix_list_id = aws_vpc_endpoint.dimo-solar-kms-vpce.prefix_list_id
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

  # Local Route
  route {
    cidr_block = var.vpc_cidr
    gateway_id = "local"
  }

  # S3 Prefix List route
  route {
    destination_prefix_list_id = aws_vpc_endpoint.dimo-solar-s3-vpce.prefix_list_id
    gateway_id     = "${aws_vpc_endpoint.dimo-solar-s3-vpce.id}"
  }

  # SSM Prefix List route
  route {
    destination_prefix_list_id = aws_vpc_endpoint.dimo-solar-ssm-vpce.prefix_list_id
  }

  # SSM Messages Prefix List route
  route {
    destination_prefix_list_id = aws_vpc_endpoint.dimo-solar-ssm-messages-vpce.prefix_list_id
  }

  # EC2 Messages Prefix List route
  route {
    destination_prefix_list_id = aws_vpc_endpoint.dimo-solar-ec2-messages-vpce.prefix_list_id
  }

  # KMS Prefix List route
  route {
    destination_prefix_list_id = aws_vpc_endpoint.dimo-solar-kms-vpce.prefix_list_id
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
    port     = 3000
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

#Security Group for VPC Endpoint to S3
resource "aws_security_group" "dimo-solar-vpce-s3-sg-test-apse1" {
    vpc_id = aws_vpc.dimo-solar-vpc-test-apse1.id
    name = "${var.project_name}-vpce-s3-sg-${var.env}-${var.region_suffix}"
    description = "Security group for VPC Endpoint to S3"
    
    tags = {
        Name = "${var.project_name}-vpce-s3-sg-${var.env}-${var.region_suffix}"
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
      vpce_s3 = aws_security_group.dimo-solar-vpce-s3-sg-test-apse1.id
    }

    security_group_id = each.value
    ip_protocol       = "-1"
    from_port         = 0
    to_port           = 0
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

# Egress rule to allow all TCP traffic to port 443 from lambda and Endpoint SGs
resource "aws_vpc_security_group_egress_rule" "allow-tcp-to-443-port-from-lambda-and-endpoint" {
    security_group_id = aws_security_group.dimo-solar-lambda-sg-test-apse1.id
    ip_protocol       = "tcp"
    from_port         = 443
    to_port           = 443 
    referenced_security_group_id = aws_security_group.dimo-solar-vpce-s3-sg-test-apse1.id
}

#--------------------End of Egress Rules ---------------------



#------------------- All Ingress Rules ------------------------

# Ingress rule to allow all TCP traffic from port 443
resource "aws_vpc_security_group_ingress_rule" "allow-all-tcp-from-443" {
    for_each = {
      ec2    = aws_security_group.dimo-solar-ec2-sg-test-apse1.id
      lambda = aws_security_group.dimo-solar-lambda-sg-test-apse1.id
    }

    security_group_id = aws_security_group.dimo-solar-vpce-s3-sg-test-apse1.id
    ip_protocol       = "tcp"
    description = "Allow TCP traffic from port 443 S3, Type Https"
    from_port         = 443
    to_port           = 443 
    cidr_ipv4         = "0.0.0.0/0"
    referenced_security_group_id =  each.value
} 

# Ingress rule to allow TCP traffic from port 5432 from Internet
resource "aws_vpc_security_group_ingress_rule" "allow-all-tcp-from-5432" {
    security_group_id = aws_security_group.dimo-solar-ec2-sg-test-apse1.id
    ip_protocol       = "tcp"
    description = "Allow TCP traffic from port 5432 PostgreSQL"
    from_port         = 5432
    to_port           = 5432 
    cidr_ipv4 =  "0.0.0.0/16"
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

# Ingress rule to allow TCP traffic from port 3000
resource "aws_vpc_security_group_ingress_rule" "allow-tcp-from-3000" {
    security_group_id = aws_security_group.dimo-solar-ec2-sg-test-apse1.id
    ip_protocol       = "tcp"
    description = "Allow TCP traffic from port 3000 Grafana"
    from_port         = 3000
    to_port           = 3000 
    referenced_security_group_id = aws_security_group.dimo-solar-alb-sg-test-apse1.id
}

# Ingress rule to allow TCP traffic from port 80 from ALB to Ec2
resource "aws_vpc_security_group_ingress_rule" "allow-tcp-from-80" {
    security_group_id = aws_security_group.dimo-solar-ec2-sg-test-apse1.id
    ip_protocol       = "tcp"
    description = "Allow TCP traffic from port 80 HTTP"
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

