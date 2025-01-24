resource "aws_lambda_function" "extract" {
  function_name = "tft_data_extract_v3"
  image_uri     = "985539759250.dkr.ecr.eu-west-2.amazonaws.com/tft:latest"
  package_type  = "Image"
  role          = aws_iam_role.iam_for_lambda.arn
  timeout       = 30
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "lambda-basic-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "sts:AssumeRole",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "secrets_manager_access" {
  name = "secrets-manager-access"

  role = aws_iam_role.iam_for_lambda.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "secretsmanager:GetSecretValue",
        Resource = "arn:aws:secretsmanager:eu-west-2:985539759250:secret:RIOT_API_KEY"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "lambda_basic_execution" {
  name       = "lambda-basic-execution"
  roles      = [aws_iam_role.iam_for_lambda.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Optional: you can add a managed policy for Secrets Manager full access (for more granular control)
resource "aws_iam_policy_attachment" "secrets_manager_full_access" {
  name       = "lambda-secrets-manager-full-access"
  roles      = [aws_iam_role.iam_for_lambda.name]
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

resource "aws_iam_policy_attachment" "s3_put_access" {
  name       = "lambda-secrets-manager-full-access"
  roles      = [aws_iam_role.iam_for_lambda.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}
