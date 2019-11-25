provider "aws" {
  access_key = "AKIAWWC3LT4JSI3WOV6O"
  secret_key = "Ucij9aCRsF6LmtH6G273NHxN/Lb7I7a/LbX6oFh0"
  region     = "us-west-1"
}

resource "aws_instance" "example" {
  ami           = "ami-0b2d8d1abb76a53d8"
  instance_type = "t2.micro"
}

