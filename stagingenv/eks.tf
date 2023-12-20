/*
This file is managed by AWS Proton. Any changes made directly to this file will be overwritten the next time AWS Proton performs an update.

To manage this resource, see AWS Proton Resource: arn:aws:proton:us-east-1:656096645154:environment/stagingenv

If the resource is no longer accessible within AWS Proton, it may have been deleted and may require manual cleanup.
*/

#-------------------------------------------------------------------
# EKS Cluster
#-------------------------------------------------------------------

module "eks_blueprints" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints?ref=v4.16.0"

  cluster_name    = local.name
  cluster_version = var.environment.inputs.kubernetes_version

  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnets

  managed_node_groups = {
    default = {
      node_group_name = "default"
      instance_types  = ["m5.xlarge"]
      min_size        = 1
      max_size        = 5
      desired_size    = 3
      subnet_ids      = module.vpc.private_subnets
    }
  }

  platform_teams = {
    platform-team = {
      users = ["arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:user/${var.environment.inputs.user}"]
    }
  }

  tags = local.tags
}

#-------------------------------------------------------------------
# Kubernetes Addons
#-------------------------------------------------------------------

module "kubernetes_addons" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons?ref=v4.16.0"

  eks_cluster_id       = module.eks_blueprints.eks_cluster_id
  eks_cluster_endpoint = module.eks_blueprints.eks_cluster_endpoint
  eks_oidc_provider    = module.eks_blueprints.oidc_provider
  eks_cluster_version  = module.eks_blueprints.eks_cluster_version

  # EKS Managed Add-ons
  enable_amazon_eks_vpc_cni            = true
  enable_amazon_eks_coredns            = true
  enable_amazon_eks_kube_proxy         = true
  enable_amazon_eks_aws_ebs_csi_driver = true

  # Add-ons
  enable_aws_for_fluentbit            = var.environment.inputs.aws_for_fluentbit
  enable_aws_load_balancer_controller = var.environment.inputs.aws_load_balancer_controller
  enable_cert_manager                 = var.environment.inputs.cert_manager
  enable_karpenter                    = var.environment.inputs.karpenter
  enable_metrics_server               = var.environment.inputs.metrics_server
  enable_vpa                          = var.environment.inputs.vpa

  tags = local.tags
}
