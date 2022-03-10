locals {
  kubernetes_version = var.environment.inputs.kubernetes_version

  vpc_cidr       = var.environment.inputs.vpc_cidr
  vpc_name       = join("-", [local.tenant, local.environment, local.zone, "vpc"])
  eks_cluster_id = join("-", [local.tenant, local.environment, local.zone, "eks"])

  managed_node_groups = {
    mng = {
      node_group_name = "managed-ondemand"
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
      users = ["arn:${data.aws_partition.current.partition}:iam:${data.aws_caller_identity.current.account_id}:user/${var.environment.inputs.user}"]
    }
  }
}