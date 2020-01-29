resource "aws_s3_bucket" "alb_log" {
  bucket = local.bucket_name
  versioning {
    enabled = true
  }

  tags = {
    Name = local.bucket_name
  }
}