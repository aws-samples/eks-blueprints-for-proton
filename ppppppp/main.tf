/*
This file is managed by AWS Proton. Any changes made directly to this file will be overwritten the next time AWS Proton performs an update.

To manage this resource, see AWS Proton Resource: arn:aws:proton:us-west-2:005191682373:environment/ppppppp

If the resource is no longer accessible within AWS Proton, it may have been deleted and may require manual cleanup.
*/

#---------------------------------------------------------------
# Consume EKS Blueprints module
#---------------------------------------------------------------

module "eks_blueprints" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints?ref=v4.0.4"

  # ENV Tags
  tenant      = "${random_id.this.hex}-${local.tenant}"
  environment = local.environment
  zone        = local.zone

  # EKS Cluster VPC and Subnet mandatory config
  vpc_id             = module.aws_vpc.vpc_id
  private_subnet_ids = module.aws_vpc.private_subnets

  # EKS CONTROL PLANE VARIABLES
  cluster_version = local.eks_cluster_version
  cluster_name    = local.eks_cluster_id

  # EKS MANAGED NODE GROUPS
  managed_node_groups = local.managed_node_groups

  # Teams
  platform_teams = local.platform_teams
}

#-------------------------------------------------------------------
# Consume eks-blueprints/kubernetes-addons module
#-------------------------------------------------------------------

module "kubernetes_addons" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons?ref=v4.0.4"

  eks_cluster_id = module.eks_blueprints.eks_cluster_id

  # EKS Managed Add-ons
  enable_amazon_eks_coredns = true
  amazon_eks_coredns_config = local.amazon_eks_coredns_config

  enable_amazon_eks_kube_proxy = true
  amazon_eks_kube_proxy_config = local.amazon_eks_kube_proxy_config

  # K8s Add-ons
  enable_aws_for_fluentbit            = var.environment.inputs.aws_for_fluentbit
  enable_aws_load_balancer_controller = var.environment.inputs.aws_load_balancer_controller
  enable_cert_manager                 = var.environment.inputs.cert_manager
  enable_metrics_server               = var.environment.inputs.metrics_server
  enable_vpa                          = var.environment.inputs.vpa

  depends_on = [module.eks_blueprints.managed_node_groups]
}

