terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = "eu-west-2"
  profile = "default"
}

module "vpc" {
  source = "./modules/vpc"
}

module "iam" {
  source = "./modules/iam"
}

module "rds" {
  source      = "./modules/rds"
  db_password = var.db_password

  # Pass the subnet IDs from the VPC module
  subnet_a_id = module.vpc.subnet_a_id
  subnet_b_id = module.vpc.subnet_b_id

}

module "lambda" {
  source = "./modules/lambda"
}

module "buckets" {
  source = "./modules/buckets"
}


