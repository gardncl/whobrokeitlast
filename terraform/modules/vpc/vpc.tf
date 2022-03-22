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

resource "aws_instance" "nat_instance" {
  ami = var.nat_ami_id
  instance_type = "t3.nano"
  count = 1
  key_name = var.nat_ssh_key_name
  network_interface {
    network_interface_id = aws_network_interface.network_interface.id
    device_index = 0
  }
  user_data = <<EOT
#!/bin/bash
sudo /usr/bin/apt update
sudo /usr/bin/apt install ifupdown
/bin/echo '#!/bin/bash
if [[ $(sudo /usr/sbin/iptables -t nat -L) != *"MASQUERADE"* ]]; then
  /bin/echo 1 > /proc/sys/net/ipv4/ip_forward
  /usr/sbin/iptables -t nat -A POSTROUTING -s ${var.public_subnets} -j MASQUERADE
fi
' | sudo /usr/bin/tee /etc/network/if-pre-up.d/nat-setup
sudo chmod +x /etc/network/if-pre-up.d/nat-setup
sudo /etc/network/if-pre-up.d/nat-setup
  EOT

  tags = {
    Name = var.nat_instance_name
    Role = "nat"
  }
}

resource "aws_network_interface" "network_interface" {
  subnet_id = "${var.private_subnets}"
  source_dest_check = false
  security_groups = [aws_vpc.vpc.id]

  tags = {
    Name = "${var.nat_instance_name}_network_interface"
  }
}