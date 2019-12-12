terraform {
  backend "s3" {
    bucket = "sdo-tf-states"
    key    = "dev.tfstate"
    region = "eu-west-1"
  }
}