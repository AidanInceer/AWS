terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
  profile = "default"
}

resource "aws_s3_bucket" "terra-test-bucket-aws" {
  bucket = "terra-test-bucket-aws"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}