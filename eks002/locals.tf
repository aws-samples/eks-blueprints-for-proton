/*
This file is managed by AWS Proton. Any changes made directly to this file will be overwritten the next time AWS Proton performs an update.

To manage this resource, see AWS Proton Resource: arn:aws:proton:us-west-2:693935722839:environment/eks002

If the resource is no longer is accessible within AWS Proton, it may have been deleted and may require manual cleanup.
*/

locals {
  tenant             = var.environment.inputs.tenant
  environment        = var.environment.inputs.environment
  zone               = var.environment.inputs.zone
  kubernetes_version = "1.21"

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
  application_teams = {
    team-ramen = {
      labels = {
        name = "team-ramen",
      }
      quota = {
        "requests.cpu"    = "2000m",
        "requests.memory" = "8Gi",
        "limits.cpu"      = "4000m",
        "limits.memory"   = "16Gi",
        "pods"            = "20",
        "secrets"         = "20",
        "services"        = "20"
      }
      manifests_dir = "./manifests"
      users         = ["arn:aws:sts::829527579886:assumed-role/Admin/kuapoorv-Isengard"]
    }
  }
  platform_teams = {
    admin-team = {
      users = ["arn:aws:sts::829527579886:assumed-role/Admin/kuapoorv-Isengard"]
    }
  }
}