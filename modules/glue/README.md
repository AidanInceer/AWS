# Glue Job Script (Import External File)
resource "local_file" "glue_script" {
  filename = "${path.module}/glue_job_script.py"
  content  = file("${path.module}/scripts/glue_job_script.py") # Path to your external Python script
}

# Glue Job
resource "aws_glue_job" "example" {
  name        = "example-glue-job"
  role_arn    = aws_iam_role.glue_role.arn
  command {
    name            = "glueetl"
    script_location = "file://${local_file.glue_script.filename}"
    python_version  = "3"
  }

  default_arguments = {
    "--job-bookmark-option" = "job-bookmark-disable"
    "--enable-metrics"      = ""
    "--enable-continuous-cloudwatch-log" = "true"
  }

  max_retries = 1
  glue_version = "3.0"
  timeout      = 10
  worker_type  = "Standard"
  number_of_workers = 2
}