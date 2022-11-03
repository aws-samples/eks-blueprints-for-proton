/*
This file is managed by AWS Proton. Any changes made directly to this file will be overwritten the next time AWS Proton performs an update.

To manage this resource, see AWS Proton Resource: arn:aws:proton:us-east-1:482887269017:environment/myEnv

If the resource is no longer accessible within AWS Proton, it may have been deleted and may require manual cleanup.
*/

output "platform_teams_configure_kubectl" {
  description = "The command to use to configure the kubeconfig file to be used with kubectl."
  value = tomap({
    for k, v in module.eks_blueprints.teams[0].platform_teams_iam_role_arn : k => "aws eks --region ${data.aws_region.current.id} update-kubeconfig --name ${data.aws_eks_cluster.cluster.name}  --role-arn ${v}"
  })["platform-team"]
}

output "eks_cluster_id" {
  description = "The name of the EKS cluster."
  value       = module.eks_blueprints.eks_cluster_id
}

output "cluster_version" {
  description = "The version of the EKS cluster."
  value       = var.environment.inputs.kubernetes_version
}

output "enable_aws_load_balancer_controller" {
  description = "The flag for the Load Balancer controller."
  value       = var.environment.inputs.aws_load_balancer_controller
}

output "enable_karpenter" {
  description = "The flag for Karpenter."
  value       = var.environment.inputs.karpenter
}

output "enable_metrics_server" {
  description = "The flag for the Metric Server."
  value       = var.environment.inputs.metrics_server
}

output "enable_aws_for_fluentbit" {
  description = "The flag for the Fluentbit."
  value       = var.environment.inputs.aws_for_fluentbit
}

output "enable_cert_manager" {
  description = "The flag for Certificate Manager."
  value       = var.environment.inputs.cert_manager
}

output "enable_vpa" {
  description = "The flag for Virtual Pod Autoscaler."
  value       = var.environment.inputs.vpa
}