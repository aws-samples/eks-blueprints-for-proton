output "role" {
  description = "AWS IAM role ARN for GitHub OIDC integration"
  value       = aws_iam_role.github_actions.arn
}

output "bucket" {
  description = "Name of the Terraform state S3 bucket"
  value       = module.terraform_state_s3_bucket.s3_bucket_id
}
