#--------------------- Basic Tags ---------------------
output "vpc_name_tag" {
  value = "${var.project_name}-vpc-${var.env}-${var.region_suffix}"
}

output "private1_subnet_tag" {
  value = "${var.project_name}-private1-subnet-${var.env}-apse1a"
}

output "private2_subnet_tag" {
  value = "${var.project_name}-private2-subnet-${var.env}-apse1b"
}

output "public1_subnet_tag" {
  value = "${var.project_name}-public1-subnet-${var.env}-apse1a"
}

output "public2_subnet_tag" {
  value = "${var.project_name}-public2-subnet-${var.env}-apse1b"
}

#--------------------- Route Tables ---------------------
output "route_tables" {
  value = {
    public  = aws_route_table.dimo-solar-rtb-public-prod-apse1.id
    private1 = aws_route_table.dimo-solar-rtb-private1-apse1a.id
    private2 = aws_route_table.dimo-solar-rtb-private2-apse1b.id
  }
}

output "route_table_associations" {
  value = {
    public1_subnet_assoc  = aws_route_table_association.dimo-solar-public-rtb-assoc["public1"].id
    public2_subnet_assoc  = aws_route_table_association.dimo-solar-public-rtb-assoc["public2"].id
    private1_subnet_assoc = aws_route_table_association.dimo-solar-private1-rtb-assoc.id
    private2_subnet_assoc = aws_route_table_association.dimo-solar-private2-rtb-assoc.id
  }
}

output "routes" {
  value = {
    public_routes = aws_route_table.dimo-solar-rtb-public-prod-apse1.route[*]
    private1_routes = aws_route_table.dimo-solar-rtb-private1-apse1a.route[*]
    private2_routes = aws_route_table.dimo-solar-rtb-private2-apse1b.route[*]
  }
}

#--------------------- Security Groups ---------------------
output "security_groups" {
  value = {
    ec2     = aws_security_group.dimo-solar-ec2-sg-prod-apse1.name
    rds     = aws_security_group.dimo-solar-rds-sg-prod-apse1.name
    alb     = aws_security_group.dimo-solar-alb-sg-prod-apse1.name
    vpce_s3 = aws_security_group.dimo-solar-vpce-sg-prod-apse1.name
    lambda  = aws_security_group.dimo-solar-lambda-sg-prod-apse1.name
  }
}

#--------------------- Security Group Rules ---------------------
output "egress_rules" {
  value = {
    allow_all_to_all_ports = { for k, r in aws_vpc_security_group_egress_rule.allow-all-to-all-ports : k => {
      security_group_id = r.security_group_id
      ip_protocol       = r.ip_protocol
      from_port         = r.from_port
      to_port           = r.to_port
      cidr_ipv4         = r.cidr_ipv4
      referenced_sg     = lookup(r, "referenced_security_group_id", null)
    }}
    allow_tcp_5432_to_rds = { for k, r in aws_vpc_security_group_egress_rule.allow-tcp-to-5432-port : k => {
      security_group_id = r.security_group_id
      from_port         = r.from_port
      to_port           = r.to_port
      referenced_sg     = r.referenced_security_group_id
    }}
    allow_tcp_443_from_lambda_and_vpce = {
      security_group_id = aws_vpc_security_group_egress_rule.allow-tcp-to-443-port-from-lambda-and-endpoint.security_group_id
      from_port         = aws_vpc_security_group_egress_rule.allow-tcp-to-443-port-from-lambda-and-endpoint.from_port
      to_port           = aws_vpc_security_group_egress_rule.allow-tcp-to-443-port-from-lambda-and-endpoint.to_port
      referenced_sg     = aws_vpc_security_group_egress_rule.allow-tcp-to-443-port-from-lambda-and-endpoint.referenced_security_group_id
    }
  }
}

output "ingress_rules" {
  value = {
    allow_tcp_443_from_vpce = { for k, r in aws_vpc_security_group_ingress_rule.allow-all-tcp-from-443 : k => {
      security_group_id = r.security_group_id
      from_port         = r.from_port
      to_port           = r.to_port
      cidr_ipv4         = r.cidr_ipv4
      referenced_sg     = r.referenced_security_group_id
    }}
    allow_tcp_5432_from_internet = {
      security_group_id = aws_vpc_security_group_ingress_rule.allow-all-tcp-from-5432.security_group_id
      from_port         = aws_vpc_security_group_ingress_rule.allow-all-tcp-from-5432.from_port
      to_port           = aws_vpc_security_group_ingress_rule.allow-all-tcp-from-5432.to_port
      cidr_ipv4         = aws_vpc_security_group_ingress_rule.allow-all-tcp-from-5432.cidr_ipv4
    }
    allow_tcp_5432_from_ec2_lambda = { for k, r in aws_vpc_security_group_ingress_rule.allow-tcp-from-5432 : k => {
      security_group_id = r.security_group_id
      from_port         = r.from_port
      to_port           = r.to_port
      referenced_sg     = r.referenced_security_group_id
    }}
    allow_tcp_3000_from_alb = {
      security_group_id = aws_vpc_security_group_ingress_rule.allow-tcp-to-3000.security_group_id
      to_port           = aws_vpc_security_group_ingress_rule.allow-tcp-to-3000.to_port
      referenced_sg     = aws_vpc_security_group_ingress_rule.allow-tcp-to-3000.referenced_security_group_id
    }
    allow_tcp_80_from_alb = {
      security_group_id = aws_vpc_security_group_ingress_rule.allow-tcp-from-80.security_group_id
      from_port         = aws_vpc_security_group_ingress_rule.allow-tcp-from-80.from_port
      to_port           = aws_vpc_security_group_ingress_rule.allow-tcp-from-80.to_port
      referenced_sg     = aws_vpc_security_group_ingress_rule.allow-tcp-from-80.referenced_security_group_id
    }
    allow_http_from_anywhere = {
      security_group_id = aws_vpc_security_group_ingress_rule.allow-http-from-anywhere.security_group_id
      from_port         = aws_vpc_security_group_ingress_rule.allow-http-from-anywhere.from_port
      to_port           = aws_vpc_security_group_ingress_rule.allow-http-from-anywhere.to_port
      cidr_ipv4         = aws_vpc_security_group_ingress_rule.allow-http-from-anywhere.cidr_ipv4
    }
  }
}


#--------------------- All Variables for Reference ---------------------
output "all_variables" {
  value = {
    project_name                      = var.project_name
    env                               = var.env
    region_suffix                     = var.region_suffix
    vpc_cidr                          = var.vpc_cidr
    apse1a_private1_subnet_cidr       = var.apse1a_private1_subnet_cidr
    apse1b_private2_subnet_cidr       = var.apse1b_private2_subnet_cidr
    apse1a_public1_subnet_cidr        = var.apse1a_public1_subnet_cidr
    apse1b_public2_subnet_cidr        = var.apse1b_public2_subnet_cidr
    ec2_instance_type                  = var.ec2_instance_type
    ec2_ami                            = var.ec2_ami
    iam_instance_profile               = aws_iam_instance_profile.solar_monitoring_ec2_ssm.name
  }
}

