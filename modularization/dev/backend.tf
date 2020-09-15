terraform {
  backend "s3" {
    bucket = "psp-tf-states"
    key    = "dev.tfstate"
    region = "eu-west-1"
  }
}