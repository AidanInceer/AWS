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
  source = "./modules/VPC"
}

module "lambda" {
  source = "./modules/lambda"
}

module "buckets" {
  source = "./modules/buckets"
}
