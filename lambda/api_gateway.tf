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

# Not recommended for parent resource
/*
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
}*/
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

# Everytime you add new resource it has to deployed to new/existing stage
# if we do it from UI and plan it there will be no change
resource "aws_api_gateway_deployment" "second_deployment" {
  depends_on = [
    aws_api_gateway_integration.second
  ]

  rest_api_id = aws_api_gateway_rest_api.example.id
  stage_name  = "test"
}

output "second_deployment" {
  value = aws_api_gateway_deployment.second_deployment.invoke_url
}
#------------------------------------------------------------------------------------------


#------------------------------- First Nested lambda --------------------------------------------

resource "aws_api_gateway_resource" "first_nested" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  parent_id   = aws_api_gateway_resource.first.id
  path_part   = "nested"
}

resource "aws_api_gateway_resource" "first_nested_proxy" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  parent_id   = aws_api_gateway_resource.first_nested.id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "first_nested_proxy" {
  rest_api_id   = aws_api_gateway_rest_api.example.id
  resource_id   = aws_api_gateway_resource.first_nested_proxy.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "first_nested_proxy" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  resource_id = aws_api_gateway_method.first_nested_proxy.resource_id
  http_method = aws_api_gateway_method.first_nested_proxy.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.first_nested_lambda.invoke_arn
}

resource "aws_api_gateway_deployment" "first_nested_deployment" {
  depends_on = [
    aws_api_gateway_integration.first_nested_proxy
  ]

  rest_api_id = aws_api_gateway_rest_api.example.id
  stage_name  = "test"
}

output "first_nested_deployment" {
  value = aws_api_gateway_deployment.first_nested_deployment.invoke_url
}
#------------------------------------------------------------------------------------------