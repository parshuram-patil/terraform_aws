variable "AWS_REGION" {
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

variable "WIN_AMIS" {
  type = map(string)
  default = {
    us-east-1 = "ami-08b11fc5bd2026dee"
    eu-west-1 = "ami-00f8336af4b6b40bf"
  }
}

