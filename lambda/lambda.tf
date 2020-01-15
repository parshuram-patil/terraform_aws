locals {
  lambda_zip_location = "output/welcome.zip"
}

data "archive_file" "welcome" {
  type        = "zip"
  source_file = "welcome.py"
  output_path = local.lambda_zip_location
}

resource "aws_lambda_function" "test_lambda" {
  filename      = local.lambda_zip_location
  function_name = "welcome"
  role          = aws_iam_role.psp_lambda_role.arn
  handler       = "welcome.hello"
  memory_size   = 250

  source_code_hash = filebase64sha256(data.archive_file.welcome.output_path)

  runtime = "python3.7"
}

output "arn" {
  value = aws_lambda_function.test_lambda.arn
}