# https://kenhalbert.com/posts/creating-an-aws-vpc-with-terraform
# https://kenhalbert.com/posts/creating-an-ec2-nat-instance-in-aws
# https://adamtheautomator.com/terraform-vpc/

resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_blocks.vpc_cidr
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id =  aws_vpc.vpc.id               # vpc_id will be generated after we create VPC
}

resource "aws_subnet" "publicsubnets" {
  vpc_id =  aws_vpc.vpc.id
  cidr_block = "${var.public_subnets}"
}

resource "aws_subnet" "privatesubnets" {
  vpc_id =  aws_vpc.vpc.id
  cidr_block = "${var.private_subnets}"          # CIDR block of private subnets
}

resource "aws_route_table" "public_route_table" {
  vpc_id =  aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"               # Traffic from Public Subnet reaches Internet via Internet Gateway
    gateway_id = aws_internet_gateway.igw.id
  }
}
