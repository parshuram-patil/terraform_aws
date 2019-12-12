locals {
  AWS_REGION = "eu-west-1"
}

provider "aws" {
  region = local.AWS_REGION
}

module "instance" {
  source             = "../modules/instance"
  AWS_REGION         = local.AWS_REGION
  KEY_NAME           = "psp-ireland-key-pair"
  SECURITY_GROUP_IDS = ["sg-0166739d8026357be"]
  SUBNET_ID          = "subnet-68d02c21"
  TAG_NAME           = "Test Windows Server"
}