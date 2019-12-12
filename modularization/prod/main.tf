locals {
  AWS_REGION = "us-east-1"
}

provider "aws" {
  region = local.AWS_REGION
}

module "instance" {
  source             = "../modules/instance"
  AWS_REGION         = local.AWS_REGION
  KEY_NAME           = "psp-n-verginia-key-pair"
  SECURITY_GROUP_IDS = [aws_security_group.allow-rdp.id]
  SUBNET_ID          = "subnet-baef1996"
}

resource "aws_security_group" "allow-rdp" {
  vpc_id      = "vpc-ef4d5489"
  name        = "allow-rdp"
  description = "allow RDP"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}