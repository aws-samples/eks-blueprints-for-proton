/*
This file is managed by AWS Proton. Any changes made directly to this file will be overwritten the next time AWS Proton performs an update.

To manage this resource, see AWS Proton Resource: arn:aws:proton:us-west-2:336419811389:environment/myeks14

If the resource is no longer accessible within AWS Proton, it may have been deleted and may require manual cleanup.
*/

output "platform_teams_configure_kubectl" {
  description = "Configure kubectl for each Platform Team."
  value = tomap({
    for k, v in module.aws-eks-accelerator-for-terraform.teams[0].platform_teams_iam_role_arn : k => "aws eks --region ${data.aws_region.current.id} update-kubeconfig --name ${data.aws_eks_cluster.cluster.name}  --role-arn ${v}"
  })["platform-team"]
}
