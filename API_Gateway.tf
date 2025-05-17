/*resource "aws_api_gateway_rest_api" "example_api" {
name = "example-api"
description = "Example API Gateway"
}

resource "aws_api_gateway_resource" "example_resource" {
rest_api_id = aws_api_gateway_rest_api.example_api.id
parent_id = aws_api_gateway_rest_api.example_api.root_resource_id
path_part = "example"
}

resource "aws_api_gateway_method" "example_method" {
rest_api_id = aws_api_gateway_rest_api.example_api.id
resource_id = aws_api_gateway_resource.example_resource.id
http_method = "GET"
authorization = "NONE"
}

resource "aws_api_gateway_integration" "example_integration" {
rest_api_id = aws_api_gateway_rest_api.example_api.id
resource_id = aws_api_gateway_resource.example_resource.id
http_method = aws_api_gateway_method.example_method.http_method
integration_http_method = "GET"
type = "AWS_PROXY"
uri = "arn:aws:lambda:us-east-1:${data.aws_caller_identity.current.account_id}:function:example-lambda"
}

resource "aws_api_gateway_deployment" "example_deployment" {
depends_on = [aws_api_gateway_integration.example_integration]
rest_api_id = aws_api_gateway_rest_api.example_api.id
stage_name = "dev"
}

data "aws_caller_identity" "current" {}

output "api_endpoint" {
value = aws_api_gateway_deployment.example_deployment.invoke_url
} */

#############################

/*
provider "aws" {
  region = "us-east-1"  # Change to your desired region
}*/

resource "aws_api_gateway_rest_api" "example" {
  name        = "example-api"
  description = "Example API Gateway"
}

resource "aws_api_gateway_resource" "example_resource" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  parent_id   = aws_api_gateway_rest_api.example.root_resource_id
  path_part   = "example"
}

resource "aws_api_gateway_method" "example_method" {
  rest_api_id   = aws_api_gateway_rest_api.example.id
  resource_id   = aws_api_gateway_resource.example_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "example_integration" {
  rest_api_id             = aws_api_gateway_rest_api.example.id
  resource_id             = aws_api_gateway_resource.example_resource.id
  http_method             = aws_api_gateway_method.example_method.http_method
  integration_http_method = "GET"
  type                    = "MOCK"  # Change to "AWS_PROXY" for Lambda integration
}

resource "aws_api_gateway_deployment" "example_deployment" {
  rest_api_id = aws_api_gateway_rest_api.example.id

  depends_on = [aws_api_gateway_integration.example_integration]
}

resource "aws_api_gateway_stage" "example_stage" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  stage_name  = "v1"
  deployment_id = aws_api_gateway_deployment.example_deployment.id
}

/*
output "invoke_url" {
  value = "${aws_api_gateway_rest_api.example.execution_arn}/${aws_api_gateway_stage.example_stage.stage_name}/example"
}*/