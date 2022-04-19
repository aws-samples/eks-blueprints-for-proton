output "platform_teams_configure_kubectl" {
  description = "Configure kubectl for each Platform Team."
  value = tomap({
    for k, v in module.eks_blueprints.teams[0].platform_teams_iam_role_arn : k => "aws eks --region ${data.aws_region.current.id} update-kubeconfig --name ${data.aws_eks_cluster.cluster.name}  --role-arn ${v}"
  })["platform-team"]
}

output "eks_cluster_id" {
  value = module.eks_blueprints.eks_cluster_id
}
