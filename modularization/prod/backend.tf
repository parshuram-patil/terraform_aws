terraform {
  backend "s3" {
    bucket = "psp-tf-states"
    key    = "prod.tfstate"
    region = "eu-west-1"
  }
}