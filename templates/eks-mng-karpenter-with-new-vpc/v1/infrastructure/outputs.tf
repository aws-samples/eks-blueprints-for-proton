output "configure_kubectl" {
  description = "Outputs of Blueprints module"
  value       = "${module.aws-eks-accelerator-for-terraform.configure_kubectl}"
}