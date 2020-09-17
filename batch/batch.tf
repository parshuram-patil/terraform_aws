
resource "aws_batch_compute_environment" "psp_spot_batch_compute_environment" {
  compute_environment_name = "psp-tf-spot-batch-compute-environment"
  compute_resources {
    instance_role       = aws_iam_instance_profile.psp_instance_profile.arn
    instance_type       = ["optimal"]
    max_vcpus           = 6
    min_vcpus           = 0
    desired_vcpus       = 0
    allocation_strategy = "SPOT_CAPACITY_OPTIMIZED"
    type                = "SPOT"
    spot_iam_fleet_role = aws_iam_role.psp_spot_fleet_tagging_role.arn
    security_group_ids  = [data.aws_security_group.allow_ssh.id]
    subnets             = [var.subnet_1]
    ec2_key_pair        = aws_key_pair.psp_keypair.key_name
  }
  service_role = aws_iam_role.psp_batch_service_role.arn
  type         = "MANAGED"
  depends_on   = [aws_iam_role_policy_attachment.psp_ecs_instance_role_attachment, aws_iam_role_policy_attachment.psp_batch_service_role_attach]
}


resource "aws_batch_job_queue" "psp_spot_batch_queue" {
  name                 = "psp-tf-spot-batch-queue"
  state                = "ENABLED"
  priority             = 10
  compute_environments = [aws_batch_compute_environment.psp_spot_batch_compute_environment.arn]
}

resource "aws_batch_job_definition" "psp_spot_batch_job_definition" {
  name = "psp-tf-spot-batch-job-definition"
  type = "container"
  retry_strategy {
    attempts = 1
  }
  container_properties = <<EOF
{
"image":"${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com/${aws_ecr_repository.psp_ecr_repo.name}:latest",
"jobRoleArn":"${aws_iam_role.psp_job_defination_role.arn}",
"vcpus":1,
"memory": 512,
"command": [],
"volumes": [],
"environment": [],
"mountPoints": [],
"ulimits": [],
"resourceRequirements": []
}
EOF
}

resource "aws_batch_compute_environment" "psp_on_demand_batch_compute_environment" {
  compute_environment_name = "psp-tf-on-demand-batch-compute-environment"
  compute_resources {
    instance_role       = aws_iam_instance_profile.psp_instance_profile.arn
    instance_type       = ["optimal"]
    max_vcpus           = 8
    min_vcpus           = 0
    desired_vcpus       = 0
    allocation_strategy = "BEST_FIT_PROGRESSIVE"
    type                = "EC2"
    security_group_ids  = [data.aws_security_group.allow_ssh.id]
    subnets             = [var.subnet_1]
    ec2_key_pair        = aws_key_pair.psp_keypair.key_name
  }
  service_role = aws_iam_role.psp_batch_service_role.arn
  type         = "MANAGED"
  depends_on   = [aws_iam_role_policy_attachment.psp_ecs_instance_role_attachment, aws_iam_role_policy_attachment.psp_batch_service_role_attach]
}

resource "aws_batch_job_queue" "psp_on_demand_batch_queue" {
  name                 = "psp-tf-on-demand-batch-queue"
  state                = "ENABLED"
  priority             = 10
  compute_environments = [aws_batch_compute_environment.psp_on_demand_batch_compute_environment.arn]
}


resource "aws_batch_job_definition" "psp_on_demand_batch_job_definition" {
  name = "psp-tf-on-demand-job-definition"
  type = "container"
  container_properties = <<EOF
{
"image":"${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com/${aws_ecr_repository.psp_ecr_repo.name}:latest",
"jobRoleArn":"${aws_iam_role.psp_job_defination_role.arn}",
"vcpus":1,
"memory": 1024,
"command": [],
"volumes": [],
"environment": [],
"mountPoints": [],
"ulimits": [],
"resourceRequirements": []
}
EOF
}

