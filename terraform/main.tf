# Require TF version to be same as or greater than 0.12.13
terraform {
  required_providers {
    aws = {
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

# Call the seed_module to build our ADO seed info
module "bootstrap" {
  source                      = "./modules/bootstrap"
  name_of_s3_bucket	      = "wbil-tf-bucket"
  dynamo_db_table_name        = "aws-locks"
}
