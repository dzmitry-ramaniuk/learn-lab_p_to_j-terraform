terraform {
  required_providers {
    awscc = {
      source  = "hashicorp/awscc"
      version = "1.2.0"
    }
  }
}
resource "aws_api_gateway_rest_api" "lab_api" {
  name = "lab_api"
}

resource "aws_api_gateway_resource" "lab_resource" {
  rest_api_id = aws_api_gateway_rest_api.lab_api.id
  parent_id   = aws_api_gateway_rest_api.lab_api.root_resource_id
  path_part   = "registration"
}

resource "aws_api_gateway_method" "lab_registration_method" {
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.lab_resource.id
  rest_api_id   = aws_api_gateway_rest_api.lab_api.id
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lab_registration_integration" {
  http_method             = aws_api_gateway_method.lab_registration_method.http_method
  resource_id             = aws_api_gateway_resource.lab_resource.id
  rest_api_id             = aws_api_gateway_rest_api.lab_api.id
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = var.lambda_registration_arn
}

resource "aws_lambda_permission" "lab_registration_lambda_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_registration_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.lab_api.execution_arn}/*/*/*"
}

resource "aws_api_gateway_deployment" "lab_deployment" {
  rest_api_id = aws_api_gateway_rest_api.lab_api.id
  stage_name  = "lab"

  depends_on = [
    aws_api_gateway_integration.lab_registration_integration
  ]
}

resource "aws_api_gateway_stage" "lab_stage" {
  deployment_id = aws_api_gateway_deployment.lab_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.lab_api.id
  stage_name    = "lab"

  lifecycle {
    ignore_changes = [deployment_id]
  }
}