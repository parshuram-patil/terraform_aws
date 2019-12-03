resource "aws_iam_role_policy" "psp_lambda_policy" {
  name = "psp_lambda_policy"
  role = aws_iam_role.psp_lambda_role.id

  policy = file("iam/lamda-policy.json")
}

resource "aws_iam_role" "psp_lambda_role" {
  name = "psp_lambda_role"
  assume_role_policy = file("iam/lambda-assume-policy.json")
}