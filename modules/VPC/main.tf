resource "aws_default_vpc" "main" {
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "main-vpc"
  }
}

# Subnet A in AZ eu-west-2a
resource "aws_default_subnet" "subnet_a" {
  availability_zone = "eu-west-2a"
}

# Subnet B in AZ eu-west-2b
resource "aws_default_subnet" "subnet_b" {
  availability_zone = "eu-west-2b"
}

# Subnet C in AZ eu-west-2c
resource "aws_default_subnet" "subnet_c" {
  availability_zone = "eu-west-2c"
}
