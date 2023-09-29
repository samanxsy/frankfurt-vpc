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

  # Tags
  vpc_tags = {
    Name        = "frankfurt-vpc"
    Environment = "Dev"
  }
}
