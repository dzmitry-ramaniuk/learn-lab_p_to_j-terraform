resource "aws_lambda_function" "registration" {
  function_name = "registration"
  role          = var.lambda_exec_role_arn
  handler       = "index.handler"
  runtime       = "nodejs20.x"

  s3_bucket = "lambda-source-lab-dr-2024"
  s3_key    = "registration.zip"
}