/*
This file is managed by AWS Proton. Any changes made directly to this file will be overwritten the next time AWS Proton performs an update.

To manage this resource, see AWS Proton Resource: arn:aws:proton:us-west-2:336419811389:environment/myeks2

If the resource is no longer accessible within AWS Proton, it may have been deleted and may require manual cleanup.
*/

output "configure_kubectl" {
  description = "Outputs of Blueprints module"
  value       = module.aws-eks-accelerator-for-terraform.configure_kubectl
}