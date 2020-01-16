resource "aws_api_gateway_rest_api" "example" {
  name        = "ServerlessExample"
  description = "Terraform Serverless Application Example"
}

#------------------------------- First lambda --------------------------------------------

resource "aws_api_gateway_resource" "first" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  parent_id   = aws_api_gateway_rest_api.example.root_resource_id
  path_part   = "user"
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
#------------------------------------------------------------------------------------------


#------------------------------- Second lambda --------------------------------------------

#------------------------------------------------------------------------------------------


resource "aws_api_gateway_deployment" "example" {
  depends_on = [
    aws_api_gateway_integration.first
  ]

  rest_api_id = aws_api_gateway_rest_api.example.id
  stage_name  = "test"
}

output "base_url" {
  value = aws_api_gateway_deployment.example.invoke_url
}