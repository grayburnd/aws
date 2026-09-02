data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "bucket" {
  bucket        = "${var.application_prefix}-s3-bucket-${data.aws_caller_identity.current.account_id}"
  force_destroy = true
}

resource "aws_s3_bucket_lifecycle_configuration" "lifecycle" {
  bucket = aws_s3_bucket.bucket.bucket
  rule {
    id     = "catch_all_expire"
    status = "Enabled"
    expiration {
      days = 30
    }
  }
}