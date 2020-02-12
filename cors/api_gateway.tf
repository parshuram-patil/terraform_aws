resource "aws_api_gateway_rest_api" "cors_api" {
  name        = "MyAPI"
  description = "An API for demonstrating CORS-enabled methods."
}
resource "aws_api_gateway_resource" "cors_resource" {
  path_part   = "Employee"
  parent_id   = aws_api_gateway_rest_api.cors_api.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.cors_api.id
}
resource "aws_api_gateway_method" "options_method" {
  rest_api_id   = aws_api_gateway_rest_api.cors_api.id
  resource_id   = aws_api_gateway_resource.cors_resource.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}
resource "aws_api_gateway_method_response" "options_200" {
  rest_api_id = aws_api_gateway_rest_api.cors_api.id
  resource_id = aws_api_gateway_resource.cors_resource.id
  http_method = aws_api_gateway_method.options_method.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
  depends_on = [aws_api_gateway_method.options_method]
}

resource "aws_api_gateway_integration" "options_integration" {
  rest_api_id = aws_api_gateway_rest_api.cors_api.id
  resource_id = aws_api_gateway_resource.cors_resource.id
  http_method = aws_api_gateway_method.options_method.http_method
  type        = "MOCK"
  depends_on  = [aws_api_gateway_method.options_method]
}
resource "aws_api_gateway_integration_response" "options_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.cors_api.id
  resource_id = aws_api_gateway_resource.cors_resource.id
  http_method = aws_api_gateway_method.options_method.http_method
  status_code = aws_api_gateway_method_response.options_200.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
  response_templates = {
    "application/json" = ""
  }
  depends_on = [aws_api_gateway_method_response.options_200]
}

resource "aws_api_gateway_method" "cors_method" {
  rest_api_id   = aws_api_gateway_rest_api.cors_api.id
  resource_id   = aws_api_gateway_resource.cors_resource.id
  http_method   = "ANY"
  authorization = "NONE"
}
resource "aws_api_gateway_method_response" "cors_method_response_200" {
  rest_api_id = aws_api_gateway_rest_api.cors_api.id
  resource_id = aws_api_gateway_resource.cors_resource.id
  http_method = aws_api_gateway_method.cors_method.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
  depends_on = [aws_api_gateway_method.cors_method]
}
resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.cors_api.id
  resource_id             = aws_api_gateway_resource.cors_resource.id
  http_method             = aws_api_gateway_method.cors_method.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.first_lambda.invoke_arn
  depends_on              = [aws_api_gateway_method.cors_method, aws_lambda_function.first_lambda]
}
resource "aws_api_gateway_integration_response" "cors_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.cors_api.id
  resource_id = aws_api_gateway_resource.cors_resource.id
  http_method = aws_api_gateway_method.cors_method.http_method
  status_code = aws_api_gateway_method_response.cors_method_response_200.status_code

  response_templates = {
    "application/json" = ""
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  depends_on = [aws_api_gateway_method_response.cors_method_response_200]
}
resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.cors_api.id
  stage_name  = "v1"
  depends_on  = [aws_api_gateway_integration.integration]
}