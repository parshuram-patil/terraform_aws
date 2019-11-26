variable "AWS_ACCESS_KEY" {
}

variable "AWS_SECRET_KEY" {
}

variable "AWS_REGION" {
  default = "us-west-1"
}

variable "AMIS" {
  type = map(string)
  default = {
    us-east-1 = "ami-00068cd7555f543d5"
    us-west-1 = "ami-0b2d8d1abb76a53d8"
  }
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "pspkey"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "pspkey.pub"
}

variable "INSTANCE_USERNAME" {
  default = "ec2-user"
}

