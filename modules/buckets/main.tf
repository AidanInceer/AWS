

resource "aws_s3_bucket" "dev-bucket" {
  bucket = "tft-project-dev-bucket"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
