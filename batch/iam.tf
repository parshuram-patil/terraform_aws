resource "aws_key_pair" "psp_keypair" {
  key_name   = "psp-batch-key-par"
  public_key = file(var.public_key)
}

resource "aws_iam_instance_profile" "psp_instance_profile" {
  name = "psp-instance-profile"
  role = aws_iam_role.psp_batch_instance_role.name
}

resource "aws_iam_role" "psp_batch_instance_role" {
  name               = "psp-batch-instance-role"
  assume_role_policy = data.aws_iam_policy_document.psp_batch_instance_role_document.json
}

data "aws_iam_policy_document" "psp_batch_instance_role_document" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "psp_ecs_instance_role_attachment" {
  role       = aws_iam_role.psp_batch_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role" "psp_spot_fleet_tagging_role" {
  name               = "psp_spot_fleet_tagging_role"
  assume_role_policy = data.aws_iam_policy_document.psp_spot_fleet_assume_role_policy.json
}

data "aws_iam_policy_document" "psp_spot_fleet_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["spotfleet.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "psp_batch_service_role" {
  name = "psp-batch-service-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "batch.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "psp_batch_service_role_attach" {
  role       = aws_iam_role.psp_batch_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBatchServiceRole"
}


resource "aws_iam_role" "psp_job_defination_role" {
  name        = "psp-job-defination-role"
  assume_role_policy = data.aws_iam_policy_document.psp_job_defination_role_doc.json
}

data "aws_iam_policy_document" "psp_job_defination_role_doc" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "psp_job_defination_role_attachment" {
  policy_arn = aws_iam_policy.psp_ecr_policy.arn
  role       = aws_iam_role.psp_job_defination_role.name
}

resource "aws_iam_policy" "psp_ecr_policy" {
  name        = "psp-ecr-policy"
  path        = "/"
  policy      = data.aws_iam_policy_document.ecr_policy_doc.json
}

data "aws_iam_policy_document" "ecr_policy_doc" {
  statement {
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:PutImage",
    ]
    resources = [
      aws_ecr_repository.psp_ecr_repo.arn
    ]
  }
  statement {
    actions   = ["ecr:GetAuthorizationToken", "logs:CreateLogStream", "logs:PutLogEvents"]
    resources = ["*"]
  }
}


//resource "aws_iam_role" "psp_batch_job_schedular_role" {
//  name = "psp-batch-job-schedular-role"
//  assume_role_policy = <<DOC
//{
//  "Version": "2012-10-17",
//  "Statement": [
//    {
//      "Sid": "",
//      "Effect": "Allow",
//      "Principal": {
//        "Service": "events.amazonaws.com"
//      },
//      "Action": "sts:AssumeRole"
//    }
//  ]
//}
//DOC
//}

data "aws_iam_policy_document" "psp_submit_batch_job_policy_doc" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "batch:SubmitJob"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "psp_submit_batch_job_policy" {
  name        = "psp-submit-batch-job-policy"
  path        = "/"
  description = "Policy to sumbit batch job"
  policy      = data.aws_iam_policy_document.psp_submit_batch_job_policy_doc.json
}

//resource "aws_iam_role_policy_attachment" "psp_batch_job_submit_policy_attachment" {
//  role       = aws_iam_role.psp_batch_job_schedular_role.name
//  policy_arn = aws_iam_policy.psp_submit_batch_job_policy.arn
//}

resource "aws_iam_role" "psp_trigger_batch_job_lambda_role" {
  name = "psp-trigger-batch-job-lambda-role"
  assume_role_policy = <<DOC
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
DOC
}

resource "aws_iam_role_policy_attachment" "psp_trigger_batch_job_lambda_ber_policy_attachment" {
  role       = aws_iam_role.psp_trigger_batch_job_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "psp_trigger_batch_job_lambda_submit_job_policy_attachment" {
  role       = aws_iam_role.psp_trigger_batch_job_lambda_role.name
  policy_arn = aws_iam_policy.psp_submit_batch_job_policy.arn
}

