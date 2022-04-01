/*
This file is managed by AWS Proton. Any changes made directly to this file will be overwritten the next time AWS Proton performs an update.

To manage this resource, see AWS Proton Resource: arn:aws:proton:us-west-2:336419811389:environment/myeks2

If the resource is no longer accessible within AWS Proton, it may have been deleted and may require manual cleanup.
*/

#---------------------------------------------------------------
# Consume aws-eks-accelerator-for-terraform module
#---------------------------------------------------------------
module "aws-eks-accelerator-for-terraform" {
  source = "github.com/aws-samples/aws-eks-accelerator-for-terraform?ref=v3.5.0"

  # ENV Tags
  tenant      = "${random_id.this.hex}-${local.tenant}"
  environment = local.environment
  zone        = local.zone

  # EKS Cluster VPC and Subnet mandatory config
  vpc_id             = module.aws_vpc.vpc_id
  private_subnet_ids = module.aws_vpc.private_subnets

  # EKS CONTROL PLANE VARIABLES
  kubernetes_version = local.kubernetes_version
  cluster_name       = local.eks_cluster_id

  # EKS MANAGED NODE GROUPS
  managed_node_groups = local.managed_node_groups

  # Teams
  platform_teams = local.platform_teams
}

#-------------------------------------------------------------------
# Consume aws-eks-accelerator-for-terraform/kubernetes-addons module
#-------------------------------------------------------------------
module "kubernetes-addons" {
  source = "github.com/aws-samples/aws-eks-accelerator-for-terraform//modules/kubernetes-addons?ref=v3.5.0"

  eks_cluster_id = module.aws-eks-accelerator-for-terraform.eks_cluster_id

  # EKS Managed Add-ons
  enable_amazon_eks_vpc_cni    = true
  amazon_eks_vpc_cni_config    = local.amazon_eks_vpc_cni_config
  enable_amazon_eks_coredns    = true
  amazon_eks_coredns_config    = local.amazon_eks_coredns_config
  enable_amazon_eks_kube_proxy = true
  amazon_eks_kube_proxy_config = local.amazon_eks_kube_proxy_config

  #K8s Add-ons
  enable_aws_load_balancer_controller = var.environment.inputs.aws_load_balancer_controller
  enable_metrics_server               = var.environment.inputs.metrics_server
  enable_aws_for_fluentbit            = var.environment.inputs.aws_for_fluentbit
  enable_cert_manager                 = var.environment.inputs.cert_manager
  enable_vpa                          = var.environment.inputs.vpa
  enable_karpenter                    = var.environment.inputs.karpenter

  depends_on = [module.aws-eks-accelerator-for-terraform.managed_node_groups]
}

