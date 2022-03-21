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

