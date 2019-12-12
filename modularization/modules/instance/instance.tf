locals {
  AMIS = {
    us-east-1 = "ami-08b11fc5bd2026dee"
    eu-west-1 = "ami-00f8336af4b6b40bf"
  }
}

resource "aws_instance" "windows_server" {
  # basic
  ami           = lookup(local.AMIS, var.AWS_REGION)
  instance_type = "t2.micro"

  # tags
  tags = {
    Name = var.TAG_NAME
  }

  # the VPC subnet
  subnet_id = var.SUBNET_ID

  # the security group
  vpc_security_group_ids = var.SECURITY_GROUP_IDS

  # the public SSH key
  key_name = var.KEY_NAME
}