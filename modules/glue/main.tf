# Upload the Glue job script to the S3 bucket
resource "aws_s3_object" "glue_script" {
  bucket = var.dev_code_bucket.bucket
  key    = "src/glue.py"
  source = "${path.module}/glue_tft.py"
  acl    = "private"

  force_destroy = true # Always overwrite the file
  etag          = md5(file("${path.module}/glue_tft.py"))
}

# Glue Job
resource "aws_glue_job" "example" {
  name     = "example-glue-job"
  role_arn = var.glue_role.arn
  command {
    name            = "glueetl"
    script_location = "s3://${aws_s3_object.glue_script.bucket}/${aws_s3_object.glue_script.key}"
    python_version  = "3"
  }

  default_arguments = {
    "--job-bookmark-option"              = "job-bookmark-disable"
    "--enable-metrics"                   = ""
    "--enable-continuous-cloudwatch-log" = "true"
  }

  max_retries       = 1
  glue_version      = "3.0"
  timeout           = 10
  worker_type       = "Standard"
  number_of_workers = 2
}
