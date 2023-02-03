output "s3_bucket" {
  description = "the s3 bucket that was created"
  value       = aws_s3_bucket.main.bucket
}


output "iam_user" {
  description = "the iam user"
  value       = aws_iam_user.protondev.name
}