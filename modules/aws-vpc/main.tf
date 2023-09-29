# Project: Frankfurt-VPC
#
# VPC Module

# VPC
resource "aws_vpc" "frankfurt_vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = var.tenancy

  tags = var.vpc_tags
}

# Public Subnets
resource "aws_subnet" "frankfurt_public_subnet" {
  count = length(var.public_subnet_cidr)

  vpc_id            = aws_vpc.frankfurt_vpc.id
  cidr_block        = element(var.public_subnet_cidr, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name        = "frankfurt-public-subnet-${count.index + 1}"
    Environment = "Prod"
  }
}

# Private Subnets
resource "aws_subnet" "frankfurt_private_subnet" {
  count = length(var.private_subnet_cidr)

  vpc_id            = aws_vpc.frankfurt_vpc.id
  cidr_block        = element(var.private_subnet_cidr, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name        = "frankfurt-private-subnet-${count.index + 1}"
    Environment = "Prod"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.frankfurt_vpc.id
  tags = {
    Name        = "internet-gateway"
    Environment = "Prod"
  }
}

# Public Route Table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.frankfurt_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name        = "frankfurt-public-route-table"
    Environment = "Prod"
  }
}

resource "aws_route_table_association" "rt_association" {
  count     = length(var.public_subnet_cidr)
  subnet_id = element(aws_subnet.frankfurt_public_subnet.*.id, count.index)

  route_table_id = aws_route_table.public_route_table.id
}
