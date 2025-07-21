data "aws_s3_bucket" "alb_access_logs" {
  bucket = local.s3_bucket_name
}