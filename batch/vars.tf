variable "subnet_1" {
  default = "subnet-68d02c21"
}


variable "public_key" {
  default = "mykey.pub"
}


data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_security_group" "allow_ssh" {
  name = "psp-allow-rdp"
}