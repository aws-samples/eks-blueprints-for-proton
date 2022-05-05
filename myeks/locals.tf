/*
This file is no longer managed by AWS Proton. The associated resource has been deleted in Proton.
*/

resource "random_id" "this" {
  byte_length = 2
}

locals {
  tenant      = "aws001"  # AWS account name or unique id for tenant
  environment = "preprod" # Environment area eg., preprod or prod
  zone        = "dev"     # Environment with in one sub_tenant or business unit

  eks_cluster_version = var.environment.inputs.kubernetes_version
  cluster_name        = var.environment.inputs.cluster_name
  eks_cluster_id      = "${random_id.this.hex}-${local.cluster_name}"

  vpc_cidr = var.environment.inputs.vpc_cidr
  vpc_name = var.environment.inputs.cluster_name
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  managed_node_groups = {
    mng = {
      node_group_name = "${local.eks_cluster_id}-managed-ondemand"
      instance_types  = ["m5.xlarge"]
      subnet_ids      = module.aws_vpc.private_subnets
      desired_size    = 1
      max_size        = 1
      min_size        = 1
    }
  }

  #---------------------------------------------------------------
  # TEAMS
  #---------------------------------------------------------------
  platform_teams = {
    platform-team = {
      users = ["arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:user/${var.environment.inputs.user}"]
    }
  }

  #----------------------------------------------------------------
  # ADD ONs
  #----------------------------------------------------------------
  amazon_eks_vpc_cni_config = {
    addon_name               = "vpc-cni"
    addon_version            = "v1.7.5-eksbuild.2"
    service_account          = "aws-node"
    resolve_conflicts        = "OVERWRITE"
    namespace                = "kube-system"
    additional_iam_policies  = []
    service_account_role_arn = ""
    tags                     = {}
  }

  amazon_eks_coredns_config = {
    addon_name               = "coredns"
    addon_version            = "v1.8.3-eksbuild.1"
    service_account          = "coredns"
    resolve_conflicts        = "OVERWRITE"
    namespace                = "kube-system"
    service_account_role_arn = ""
    additional_iam_policies  = []
    tags                     = {}
  }

  amazon_eks_kube_proxy_config = {
    addon_name               = "kube-proxy"
    addon_version            = "v1.20.7-eksbuild.1"
    service_account          = "kube-proxy"
    resolve_conflicts        = "OVERWRITE"
    namespace                = "kube-system"
    additional_iam_policies  = []
    service_account_role_arn = ""
    tags                     = {}
  }
}
