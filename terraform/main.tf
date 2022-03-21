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
  vpc_name = ""
  nat_name = "wbil_nat"
  ami_id = "ami-0c02fb55956c7d316"
  security_group_ingress_cidr_ipv4 = "0.0.0.0/0"
  ssh_key_name = ""
  subnet_id = ""
}
