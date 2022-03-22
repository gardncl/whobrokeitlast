terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 2.36.0"
    }
  }
  required_version = ">=0.12.13"
  backend "s3" {
    bucket         = "wbil-tf-bucket"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "aws-locks"
    encrypt        = true
  }
}

provider "aws" {
  profile = "default"
  region = "us-east-1"
}

module "bootstrap" {
  source                      = "./modules/bootstrap"
  name_of_s3_bucket	      = "wbil-tf-bucket"
  dynamo_db_table_name        = "aws-locks"
}

module "vpc" {
  source = "./modules/vpc"
  vpc_name = "wbil_vpc"
  public_subnets = "10.0.0.0/19"
  private_subnets = "10.0.32.0/19"
  nat_ami_id = "ami-0c02fb55956c7d316" // Amazon Linux 2 AMI (HVM) - Kernel 5.10, SSD Volume Type
  nat_ssh_key_name = "whobrokeitlast.pem"
  nat_instance_name = "wbil_nat_instance"
}

