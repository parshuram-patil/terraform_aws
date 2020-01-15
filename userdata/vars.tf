variable  "AWS_REGION" {
  default = "eu-west-1"
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "mykey"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "mykey.pub"
}

variable "AMIS" {
  type = map(string)
  default = {
    us-east-1 = "ami-00068cd7555f543d5"
    us-west-1 = "ami-0b2d8d1abb76a53d8"
    eu-west-1 = "ami-01f14919ba412de34"
  }
}

variable "OS_TYPE" {
  default = "Windows"
}

variable "PROFILE" {
  default = "sandbox"
}

variable "EBS_DEVICE_NAME_1" {
  default = "/dev/xvdh"
}

variable "EBS_DEVICE_NAME_2" {
  default = "/dev/xvdi"
}

variable "tag" {
  default = {
    Name       = "Variable Tag"
    "app:name" = "User data"
  }
}
