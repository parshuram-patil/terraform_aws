#------------------------------- API ----------------------------------------------------
resource "aws_api_gateway_rest_api" "api" {
  name              = var.api_name
  description       = var.description
  binary_media_types= var.binary_media_types
  endpoint_configuration {
    types = var.endpoint_type
  }

  tags = merge(
    { Name            = format("%s",var.api_name) },
    var.tags, 
  )
  policy = var.policy_json
}
#------------------------------- aws_api_gateway_gateway_response ----------------------------------------------------
resource "aws_api_gateway_gateway_response" "gateway_response" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  response_type = "DEFAULT_4XX"

  response_templates = {
    "application/json" = "{\"message\":$context.error.messageString}"
  }

  response_parameters = {
    "gatewayresponse.header.Access-Control-Allow-Origin" = "'*'"
  }
}
