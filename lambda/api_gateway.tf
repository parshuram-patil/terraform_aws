resource "aws_api_gateway_rest_api" "example" {
  name        = "ServerlessExample"
  description = "Terraform Serverless Application Example"
}

#------------------------------- First lambda --------------------------------------------

resource "aws_api_gateway_resource" "first" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  parent_id   = aws_api_gateway_rest_api.example.root_resource_id
  path_part   = "first"
}

resource "aws_api_gateway_method" "first_get" {
  rest_api_id   = aws_api_gateway_rest_api.example.id
  resource_id   = aws_api_gateway_resource.first.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "first" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  resource_id = aws_api_gateway_method.first_get.resource_id
  http_method = aws_api_gateway_method.first_get.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.first_lambda.invoke_arn
}

resource "aws_api_gateway_deployment" "first_deployment" {
  depends_on = [
    aws_api_gateway_integration.first
  ]

  rest_api_id = aws_api_gateway_rest_api.example.id
  stage_name  = "test"
}

output "first_deployment" {
  value = aws_api_gateway_deployment.first_deployment.invoke_url
}
#------------------------------------------------------------------------------------------


#------------------------------- Second lambda --------------------------------------------

resource "aws_api_gateway_resource" "second" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  parent_id   = aws_api_gateway_rest_api.example.root_resource_id
  path_part   = "second"
}

resource "aws_api_gateway_method" "second_get" {
  rest_api_id   = aws_api_gateway_rest_api.example.id
  resource_id   = aws_api_gateway_resource.second.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "second" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  resource_id = aws_api_gateway_method.second_get.resource_id
  http_method = aws_api_gateway_method.second_get.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.second_lambda.invoke_arn
}
#------------------------------------------------------------------------------------------