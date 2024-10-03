output "lambda_registration_arn" {
  value = aws_lambda_function.registration.invoke_arn
}

output "lambda_registration_name" {
  value = aws_lambda_function.registration.function_name
}