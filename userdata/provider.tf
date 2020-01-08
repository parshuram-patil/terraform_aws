provider "aws" {
  region = var.AWS_REGION
  profile = var.PROFILE
  shared_credentials_file = var.OS_TYPE == "Windows"? "%USERPROFILE%" : "~" + "/.aws/credentials"
}