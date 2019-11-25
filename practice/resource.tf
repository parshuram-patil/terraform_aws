provider "aws" {
	region = var.AWS_REGION
}

variable "AWS_REGION" {
	type = string
}

variable "AMIS" {
	type = map(string)
	default = {
		eu-west-1 = "my AMI"
	}
}

resource "aws_instance" "example" {
	ami = var.AMIS[var.AWS_REGION]
	instance_type = "t2.micro"
}
