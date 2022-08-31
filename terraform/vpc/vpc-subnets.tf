locals {
  subnets = {
    "us-east-1a" = { "public_cidr" : "10.1.4.0/24", "private_cidr" : "10.1.7.0/24" }
    "us-east-1b" = { "public_cidr" : "10.1.5.0/24", "private_cidr" : "10.1.8.0/24" }
    "us-east-1c" = { "public_cidr" : "10.1.6.0/24", "private_cidr" : "10.1.9.0/24" }
  }
}

# Creates new VPC.
resource "aws_vpc" "main" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "vpc_main"
  }
}

# Public subnets. 
resource "aws_subnet" "public-subnet" {
  for_each                = local.subnets
  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value["public_cidr"]
  map_public_ip_on_launch = true
  availability_zone       = each.key
  tags = {
    Name = "public-${each.key}"
  }
}


# Private subnets.
resource "aws_subnet" "private-subnet" {
  for_each                = local.subnets
  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value["private_cidr"]
  map_public_ip_on_launch = false
  availability_zone       = each.key

  tags = {
    Name = "private-${each.key}"
  }
}
