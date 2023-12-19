/*
This file is managed by AWS Proton. Any changes made directly to this file will be overwritten the next time AWS Proton performs an update.

To manage this resource, see AWS Proton Resource: arn:aws:proton:us-east-1:656096645154:environment/staging

If the resource is no longer accessible within AWS Proton, it may have been deleted and may require manual cleanup.
*/

provider "aws" {
  region = var.aws_region
}

provider "kubernetes" {
  host                   = module.eks_blueprints.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks_blueprints.eks_cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.this.token
}

provider "helm" {
  kubernetes {
    host                   = module.eks_blueprints.eks_cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks_blueprints.eks_cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}

data "aws_eks_cluster_auth" "this" {
  name = module.eks_blueprints.eks_cluster_id
}

# Update for remote backend S3 bucket, region, and key
terraform {
  backend "s3" {}
}

################################################################################
# Common Locals
################################################################################

locals {
  name = var.environment.inputs.cluster_name

  tags = {
    Name       = var.environment.inputs.cluster_name
    GithubRepo = "github.com/aws-samples/eks-blueprints-for-proton"
  }
}

################################################################################
# Common Data
################################################################################

data "aws_availability_zones" "available" {}
data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}
