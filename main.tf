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


module "lambda" {
  source = "./modules/lambda"
}

module "buckets" {
  source = "./modules/buckets"
}

module "redshift" {
  source = "./modules/redshift"
}

module "glue" {
  source     = "./modules/glue"
  glue_role  = module.iam.glue_role
  dev_code_bucket = module.buckets.dev_code_bucket
}
