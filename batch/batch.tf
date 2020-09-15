
resource "aws_batch_compute_environment" "psp_batch_compute_environment" {
  compute_environment_name = "psp-tf-batch-compute-environment"
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


resource "aws_batch_job_queue" "psp_batch_queue" {
  name                 = "psp-tf-batch-queue"
  state                = "ENABLED"
  priority             = 10
  compute_environments = [aws_batch_compute_environment.psp_batch_compute_environment.arn]
}

resource "aws_batch_job_definition" "psp_job_definition" {
  name = "psp-tf-job-definition"
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