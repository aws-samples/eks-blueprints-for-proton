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

