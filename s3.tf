# Reference existing S3 bucket using data block
data "aws_s3_bucket" "alb_access_logs" {
  bucket = local.s3_bucket_name
}

# Server-side encryption configuration
resource "aws_s3_bucket_server_side_encryption_configuration" "alb_access_logs" {
  bucket = data.aws_s3_bucket.alb_access_logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# S3 bucket policy
resource "aws_s3_bucket_policy" "alb_access_logs" {
  bucket = data.aws_s3_bucket.alb_access_logs.id

  policy = templatefile("${path.module}/templates/s3_policy.json", {
    bucket_resources = jsonencode([
      "arn:aws:s3:::${local.s3_bucket_name}",
      "arn:aws:s3:::${local.s3_bucket_name}/*"
    ])
    key_users = jsonencode([
      "arn:aws:iam::${local.account_id}:role/${local.project.resource_prefix_name}-search-v2-execution-role",
      "arn:aws:iam::${local.account_id}:role/${local.project.resource_prefix_name}-book-of-business-iac-execution-role"
    ])
  })
}

# Tags merge for resources
locals {
  common_tags = merge(
    var.default_tags,
    {
      Environment = var.environment
      Project     = var.project_name
    }
  )
}