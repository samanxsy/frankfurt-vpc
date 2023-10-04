# Project: Frankfurt-VPC
#
# Main Terraform config

module "aws-vpc" {
  source = "./modules/aws-vpc"

  # CIDR RANGE
  vpc_cidr = "10.0.0.0/16"

  # Tenancy
  tenancy = "default"

  # AZs
  availability_zones = ["eu-central-1a", "eu-central-1b"]

  # Public Subnets
  public_subnet_cidr = ["10.0.0.0/20", "10.0.32.0/20"]

  # Private Subnets
  private_subnet_cidr = ["10.0.16.0/20", "10.0.48.0/20"]

  # Network ACL **INGRESS** rules
  nacl_ingress = {
    http_access = {
      protocol   = "tcp"
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 8080
      to_port    = 8080
    },
    ssh_access = {
      protocol   = "tcp"
      rule_no    = 110
      action     = "allow"
      cidr_block = local.my_ip_address
      from_port  = 22
      to_port    = 22
    }
  }

  # Network ACL **EGRESS** rules
  nacl_egress = {
    outbound_access = {
      protocol   = "-1"
      rule_no    = 200
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 0
      to_port    = 0
    }
  }

  # Tags
  vpc_tags = {
    Name        = "frankfurt-vpc"
    Environment = "Dev"
  }
}


data "external" "my_ip_address" {
  program = ["bash", "./get_my_ip.sh"]
}

locals {
  my_ip_address = data.external.my_ip_address.result.my_public_ip
}
