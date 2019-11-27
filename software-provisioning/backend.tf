terraform {
  backend "s3" {
    bucket  = "psp-terraform-states"
    key     = "terraform/first"
    profile = "terraform"
  }
}