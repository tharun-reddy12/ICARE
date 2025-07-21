# ICARE - S3 Bucket Reference Configuration

This Terraform configuration addresses the "bucket already exists" error by using data sources to reference existing AWS S3 bucket resources instead of attempting to create new ones.

## Problem Solved

Previously, if you tried to create an S3 bucket with Terraform using a `resource "aws_s3_bucket"` block, you would get a "bucket already exists" error if the bucket was already created outside of Terraform or in a different Terraform state.

## Solution

This configuration uses `data` blocks instead of `resource` blocks to reference existing AWS resources:

- `data "aws_s3_bucket"` - References an existing S3 bucket
- `data "aws_s3_bucket_server_side_encryption_configuration"` - References existing encryption settings
- `data "aws_s3_bucket_policy"` - References existing bucket policy

## Usage

1. **Update the local values** in `main.tf`:
   - Replace `"your-existing-bucket-name"` with your actual S3 bucket name
   - Replace `"123456789012"` with your actual AWS account ID
   - Replace `"your-project-prefix"` with your actual project prefix

2. **Initialize Terraform**:
   ```bash
   terraform init
   ```

3. **Plan the configuration**:
   ```bash
   terraform plan
   ```

4. **Apply the configuration**:
   ```bash
   terraform apply
   ```

## What This Configuration Does

- References your existing S3 bucket without trying to create it
- Retrieves the current bucket policy and encryption configuration
- Provides outputs for bucket ARN, ID, and policy for use in other configurations
- Defines local values for bucket resources and IAM role ARNs

## Benefits

- ✅ No more "bucket already exists" errors
- ✅ Works with buckets created outside of Terraform
- ✅ Allows you to reference and use existing bucket properties
- ✅ Maintains Terraform state management for dependent resources

## Important Notes

- The bucket must already exist in your AWS account
- You must have appropriate permissions to read the bucket properties
- This configuration does not modify the existing bucket, only references it