resource "aws_lambda_function" "lambda_hello_world" {
  # Correct the filename to reference a zipped deployment package.
  filename      = "./aws/lambda/weather_data/main.zip" # Must point to a ZIP file
  function_name = "lambda_hello_world"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "main.lambda_handler" # Ensure the handler points to the correct file and function

  runtime = "python3.12"

  # Use source_code_hash to detect changes in the ZIP file
  source_code_hash = filebase64sha256("./aws/lambda/weather_data/main.zip")
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "lambda-basic-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "lambda_basic_execution" {
  name       = "lambda-basic-execution"
  roles      = [aws_iam_role.iam_for_lambda.name] # Correct reference to the IAM role
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
