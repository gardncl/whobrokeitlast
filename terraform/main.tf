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
}
