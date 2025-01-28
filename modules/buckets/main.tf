

resource "aws_s3_bucket" "dev-bucket" {
  bucket = "tft-project-dev-bucket"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}



resource "aws_s3_bucket" "dev_code_bucket" {
  bucket = "tft-project-dev-code-bucket"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
