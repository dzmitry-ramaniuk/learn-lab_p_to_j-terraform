resource "aws_lambda_function" "registration" {
  function_name = "registration"
  role          = var.lambda_exec_role_arn
  handler       = "index.handler"
  runtime       = "nodejs20.x"

  s3_bucket = "lambda-source-lab-dr-2024"
  s3_key    = "registration.zip"

  vpc_config {
    security_group_ids = [var.lab_vpc_security_group_id]
    subnet_ids = [var.lab_vpc_private_subnet_id]
  }
}