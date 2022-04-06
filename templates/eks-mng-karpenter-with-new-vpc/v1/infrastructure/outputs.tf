output "configure_kubectl" {
  description = "Command to configur admin access to the EKS cluster for identity that created the cluter."
  value       = module.aws-eks-accelerator-for-terraform.configure_kubectl
}

output "configure_admin_kubectl" {
  description = "Command to configure admin access the EKS cluster."
  value       = module.aws-eks-accelerator-for-terraform.teams[0].platform_teams_configure_kubectl["platform-team"]

}
