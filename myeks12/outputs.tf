/*
This file is no longer managed by AWS Proton. The associated resource has been deleted in Proton.
*/

output "platform_teams_configure_kubectl" {
  description = "Configure kubectl for each Platform Team."
  value = tomap({
    for k, v in module.aws-eks-accelerator-for-terraform.teams[0].platform_teams_iam_role_arn : k => "aws eks --region ${data.aws_region.current.id} update-kubeconfig --name ${data.aws_eks_cluster.cluster.name}  --role-arn ${v}"
  })["platform-team"]
}
