variable "AWS_REGION" {
  default = "eu-west-1"
}

variable "AMIS" {
  type = map(string)
  default = {
    us-east-1 = "ami-00068cd7555f543d5"
    us-west-1 = "ami-0b2d8d1abb76a53d8"
    eu-west-1 = "ami-01f14919ba412de34"
  }
}
