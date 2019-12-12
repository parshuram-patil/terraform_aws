variable "AWS_REGION" {
  type = string
}

variable "TAG_NAME" {
  type    = string
  default = "Windows Server"
}
variable "SUBNET_ID" {
  type = string
}

variable "SECURITY_GROUP_IDS" {
  type = set(string)
}

variable "KEY_NAME" {
  type = string
}

