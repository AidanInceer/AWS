

resource "aws_s3_bucket" "dev-bucket" {
  bucket = "dev-bucket-ai98"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
