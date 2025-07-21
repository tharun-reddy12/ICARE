# Reference existing S3 bucket using data block
data "aws_s3_bucket" "alb_access_logs" {
  bucket = local.s3_bucket_name
}

# Reference existing server-side encryption configuration
data "aws_s3_bucket_server_side_encryption_configuration" "alb_access_logs" {
  bucket = data.aws_s3_bucket.alb_access_logs.id
}

# Reference existing S3 bucket policy
data "aws_s3_bucket_policy" "alb_access_logs" {
  bucket = data.aws_s3_bucket.alb_access_logs.id
}

# Local values for reference
locals {
  # S3 bucket configuration
  s3_bucket_name = "your-bucket-name"
  account_id     = "123456789012"
  
  # Project configuration
  project = {
    resource_prefix_name = "your-project-prefix"
  }
  
  # Policy template data
  bucket_resources = [
    "arn:aws:s3:::${local.s3_bucket_name}",
    "arn:aws:s3:::${local.s3_bucket_name}/*"
  ]
  
  key_users = [
    "arn:aws:iam::${local.account_id}:role/${local.project.resource_prefix_name}-search-v2-execution-role",
    "arn:aws:iam::${local.account_id}:role/${local.project.resource_prefix_name}-book-of-business-iac-execution-role"
  ]
  
  # Common tags
  common_tags = {
    Environment = "production"
    Project     = "alb-access-logs"
    ManagedBy   = "terraform"
  }
}

# Output the referenced resources for verification
output "s3_bucket_arn" {
  description = "ARN of the referenced S3 bucket"
  value       = data.aws_s3_bucket.alb_access_logs.arn
}

output "s3_bucket_policy" {
  description = "Policy document of the referenced S3 bucket"
  value       = data.aws_s3_bucket_policy.alb_access_logs.policy
  sensitive   = true
}