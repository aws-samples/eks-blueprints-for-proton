/*
This file is managed by AWS Proton. Any changes made directly to this file will be overwritten the next time AWS Proton performs an update.

To manage this resource, see AWS Proton Resource: arn:aws:proton:us-west-2:693935722839:environment/eks001

If the resource is no longer is accessible within AWS Proton, it may have been deleted and may require manual cleanup.
*/

#---------------------------------------------------------------
# Consume aws-eks-accelerator-for-terraform module
#---------------------------------------------------------------
module "aws-eks-accelerator-for-terraform" {
  source = "github.com/aws-samples/aws-eks-accelerator-for-terraform"

  tenant      = local.tenant
  environment = local.environment
  zone        = local.zone

  # EKS Cluster VPC and Subnet mandatory config
  vpc_id             = module.aws_vpc.vpc_id
  private_subnet_ids = module.aws_vpc.private_subnets

  # EKS CONTROL PLANE VARIABLES
  create_eks         = true
  kubernetes_version = local.kubernetes_version

  # EKS MANAGED NODE GROUPS
  managed_node_groups = local.managed_node_groups

  # Teams
  platform_teams    = local.platform_teams
  application_teams = local.application_teams
}

#-------------------------------------------------------------------
# Consume aws-eks-accelerator-for-terraform/kubernetes-addons module
#-------------------------------------------------------------------
module "kubernetes-addons" {
  source = "github.com/aws-samples/aws-eks-accelerator-for-terraform//modules/kubernetes-addons"

  eks_cluster_id = module.aws-eks-accelerator-for-terraform.eks_cluster_id

  # EKS Managed Add-ons
  enable_amazon_eks_vpc_cni            = true
  enable_amazon_eks_coredns            = true
  enable_amazon_eks_kube_proxy         = true
  enable_amazon_eks_aws_ebs_csi_driver = true

  #K8s Add-ons
  enable_aws_load_balancer_controller = var.environment.inputs.aws_load_balancer_controller
  enable_metrics_server               = var.environment.inputs.metrics_server
  enable_aws_for_fluentbit            = var.environment.inputs.aws_for_fluentbit
  enable_cert_manager                 = var.environment.inputs.cert_manager
  enable_vpa                          = var.environment.inputs.vpa
  enable_karpenter                    = var.environment.inputs.karpenter
  enable_argocd                       = true

  depends_on = [module.aws-eks-accelerator-for-terraform.managed_node_groups]
}