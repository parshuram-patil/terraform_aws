locals {
  bucket_name = "psp-alb-log"
  alb_name    = "my-alb"
  subnet_1    = "subnet-68d02c21"
  subnet_2    = "subnet-95310ecd"
  aws_region  = "eu-west-1"
  sg_http     = "sg-08bf503a758f274d6"
  sg_ssh      = "sg-043b799743ea37455"
  key_name    = "siemens-ireland-key-pair"
  ami_id      = "ami-0713f98de93617bb4"
  vpc         = "vpc-897b8dee"
}
