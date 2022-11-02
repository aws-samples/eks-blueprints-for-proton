terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version = "~> 1.0"
}

variable "github_org" {
  description = "the name of the github organization"
  type        = string
}

variable "github_repo" {
  description = "the name of the github repo"
  type        = string
}

data "tls_certificate" "github_actions_oidc_provider" {
  url = "https://token.actions.githubusercontent.com/.well-known/openid-configuration"
}

# This identity provider is required to accept OpenID Connect credentials
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.github_actions_oidc_provider.certificates[0].sha1_fingerprint]
}

data "aws_iam_policy_document" "github_actions_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.github_org}/${var.github_repo}:*"]
    }
  }
}

/*
Creates the role that will be passed to Terraform to be able to deploy
infrastructure in your AWS account. You will enter this role in your
env_config.json file.

Note that this role has administrator access to your account, so that
it can be used to provision any infrastructure in your templates. We
recommend you scope down the role permissions to the resources that will be used
in your Proton templates.
*/

# the role that the github action runs as
resource "aws_iam_role" "github_actions" {
  name               = "ExampleGithubRole"
  assume_role_policy = data.aws_iam_policy_document.github_actions_assume_role.json
}

resource "aws_iam_role_policy_attachment" "github_actions" {
  role       = aws_iam_role.github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

data "aws_caller_identity" "current" {}

# This bucket will be used to store your Terraform remote state files
resource "aws_s3_bucket" "bucket" {
  bucket = "aws-proton-terraform-bucket-${data.aws_caller_identity.current.account_id}"
}

# explicitly block public access
resource "aws_s3_bucket_public_access_block" "bucket" {
  bucket                  = aws_s3_bucket.bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


# outputs

output "role" {
  value = aws_iam_role.github_actions.arn
}

output "bucket" {
  value = aws_s3_bucket.bucket.bucket
}