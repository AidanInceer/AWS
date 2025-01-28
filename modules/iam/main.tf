# IAM Role for AWS Glue
resource "aws_iam_role" "glue_role" {
  name = "aws-glue-service-role"
  assume_role_policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Principal : {
          Service : "glue.amazonaws.com"
        },
        Action : "sts:AssumeRole"
      }
    ]
  })
}

# Attach Managed Policies to the Role
resource "aws_iam_role_policy_attachment" "glue_s3_access" {
  role       = aws_iam_role.glue_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess" # Replace with a more restrictive policy if necessary
}

resource "aws_iam_role_policy_attachment" "glue_service_access" {
  role       = aws_iam_role.glue_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

# Example: Optional CloudWatch Logs Policy Attachment
resource "aws_iam_role_policy_attachment" "glue_cloudwatch_logs" {
  role       = aws_iam_role.glue_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}



# IAM Role for AWS Glue
resource "aws_iam_role" "redshift_role" {
  name = "aws-redshift-service-role"
  assume_role_policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Principal : {
          Service : "redshift.amazonaws.com"
        },
        Action : "sts:AssumeRole"
      }
    ]
  })
}


# Example: Optional CloudWatch Logs Policy Attachment
resource "aws_iam_role_policy_attachment" "full_access_redshift" {
  role       = aws_iam_role.redshift_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRedshiftAllCommandsFullAccess"
}


resource "aws_iam_policy" "glue_s3_access_policy" {
  name        = "GlueS3AccessPolicy"
  description = "Policy to allow Glue job to access S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = ["s3:GetObject", "s3:ListBucket"],
        Resource = [
          "arn:aws:s3:::tft-project-dev-bucket",  # Allow listing the bucket
          "arn:aws:s3:::tft-project-dev-bucket/*" # Allow reading objects
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "glue_s3_access_specific" {
  role       = aws_iam_role.glue_role.name
  policy_arn = aws_iam_policy.glue_s3_access_policy.arn
}
