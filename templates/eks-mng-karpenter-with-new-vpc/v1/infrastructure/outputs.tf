output "platform_teams_configure_kubectl" {
  description = "Configure kubectl for each Platform Team: make sure you're logged in with the correct AWS profile and run the following command to update your kubeconfig"
  value       = module.eks_blueprints.teams[0].platform_teams_configure_kubectl
}

output "application_teams_configure_kubectl" {
  description = "Configure kubectl for each Application Teams: make sure you're logged in with the correct AWS profile and run the following command to update your kubeconfig"
  value       = module.eks_blueprints.teams[0].application_teams_configure_kubectl
}

output "eks_cluster_id" {
  description = "The name of the EKS cluster"
  value       = module.eks_blueprints.eks_cluster_id
}

output "cluster_version" {
  description = "The version of the EKS cluster"
  value       = var.environment.inputs.kubernetes_version
}

output "enable_aws_load_balancer_controller" {
  description = "The flag for the Load Balancer controller"
  value       = var.environment.inputs.aws_load_balancer_controller
}

output "enable_karpenter" {
  description = "The flag for Karpenter"
  value       = var.environment.inputs.karpenter
}

output "enable_metrics_server" {
  description = "The flag for the Metric Server"
  value       = var.environment.inputs.metrics_server
}

output "enable_aws_for_fluentbit" {
  description = "The flag for the Fluentbit"
  value       = var.environment.inputs.aws_for_fluentbit
}

output "enable_cert_manager" {
  description = "The flag for Certificate Manager"
  value       = var.environment.inputs.cert_manager
}

output "enable_vpa" {
  description = "The flag for Virtual Pod Autoscaler"
  value       = var.environment.inputs.vpa
}
