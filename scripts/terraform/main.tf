################################################################################
# Common Locals
################################################################################

locals {
  tags = {
    GithubRepo = "github.com/aws-samples/eks-blueprints-for-proton"
  }
}

################################################################################
# Common Data
################################################################################

data "aws_caller_identity" "current" {}

################################################################################
# GitHub OIDC IAM role
/*
Creates the role that will be passed to Terraform to be able to deploy
infrastructure in your AWS account. You will enter this role in your
env_config.json file.

Note that this role has administrator access to your account, so that
it can be used to provision any infrastructure in your templates. We
recommend you scope down the role permissions to the resources that will be used
in your Proton templates.
*/
################################################################################

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

resource "aws_iam_role" "github_actions" {
  name               = "ExampleGithubRole"
  assume_role_policy = data.aws_iam_policy_document.github_actions_assume_role.json
}

resource "aws_iam_role_policy_attachment" "github_actions" {
  role       = aws_iam_role.github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

################################################################################
# Terraform remote state S3 bucket
################################################################################

module "terraform_state_s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.0"

  bucket = "aws-proton-terraform-bucket-${data.aws_caller_identity.current.account_id}"

  attach_deny_insecure_transport_policy = true
  attach_require_latest_tls_policy      = true

  acl = "private"

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  control_object_ownership = true
  object_ownership         = "BucketOwnerPreferred"

  versioning = {
    status     = true
    mfa_delete = false
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = local.tags
}
