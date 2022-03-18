/*
This file is managed by AWS Proton. Any changes made directly to this file will be overwritten the next time AWS Proton performs an update.

To manage this resource, see AWS Proton Resource: arn:aws:proton:us-east-1:829527579886:environment/blog01

If the resource is no longer accessible within AWS Proton, it may have been deleted and may require manual cleanup.
*/

locals {
  kubernetes_version = var.environment.inputs.kubernetes_version

  vpc_cidr       = var.environment.inputs.vpc_cidr
  vpc_name       = var.environment.inputs.cluster_name
  eks_cluster_id = var.environment.inputs.cluster_name
  azs            = slice(data.aws_availability_zones.available.names, 0, 3)

  managed_node_groups = {
    mng = {
      node_group_name = "${var.environment.inputs.cluster_name}-managed-ondemand"
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
}