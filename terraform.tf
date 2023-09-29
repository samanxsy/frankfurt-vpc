# Project: Frankfurt-VPC
#
# Terraform Configuration


terraform {
  cloud {
    organization = "samanxdevexp"

    workspaces {
      name = "frankfurt-vpc"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.0.0"
    }
  }
}
