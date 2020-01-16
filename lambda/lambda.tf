locals {
  lambda_zip_location = "output/welcome.zip"
}

data "archive_file" "first_archive" {
  type        = "zip"
  source_file = "code/first.py"
  output_path = local.lambda_zip_location
}

resource "aws_lambda_function" "first_lambda" {
  filename      = local.lambda_zip_location
  function_name = "first_lambda"
  role          = aws_iam_role.psp_lambda_role.arn
  handler       = "first.hello"
  memory_size   = 250

  source_code_hash = filebase64sha256(data.archive_file.first_archive.output_path)

  runtime = "python3.7"
}

resource "aws_lambda_permission" "first_lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.first_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.example.execution_arn}/*/*"
}