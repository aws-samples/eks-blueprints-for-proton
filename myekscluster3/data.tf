/*
This file is no longer managed by AWS Proton. The associated resource has been deleted in Proton.
*/

data "aws_region" "current" {}

data "aws_availability_zones" "available" {}

data "aws_partition" "current" {}

data "aws_caller_identity" "current" {}

data "aws_eks_cluster" "cluster" {
  name = module.eks_blueprints.eks_cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks_blueprints.eks_cluster_id
}

data "aws_eks_addon_version" "coredns" {
  addon_name         = "coredns"
  kubernetes_version = local.eks_cluster_version
}

data "aws_eks_addon_version" "kube_proxy" {
  addon_name         = "kube-proxy"
  kubernetes_version = local.eks_cluster_version
}
