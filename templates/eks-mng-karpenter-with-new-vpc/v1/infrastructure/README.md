# EKS Managed Node Group w/ Karpenter Template

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.10 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.4.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.6.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.10 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks_blueprints"></a> [eks\_blueprints](#module\_eks\_blueprints) | github.com/aws-ia/terraform-aws-eks-blueprints | v4.16.0 |
| <a name="module_kubernetes_addons"></a> [kubernetes\_addons](#module\_kubernetes\_addons) | github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons | v4.16.0 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | ~> 3.0 |

## Resources

| Name | Type |
|------|------|
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster_auth.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region where resources will be provisioned | `string` | `"us-west-2"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_version"></a> [cluster\_version](#output\_cluster\_version) | The version of the EKS cluster |
| <a name="output_eks_cluster_id"></a> [eks\_cluster\_id](#output\_eks\_cluster\_id) | The name of the EKS cluster |
| <a name="output_enable_aws_for_fluentbit"></a> [enable\_aws\_for\_fluentbit](#output\_enable\_aws\_for\_fluentbit) | The flag for the Fluentbit |
| <a name="output_enable_aws_load_balancer_controller"></a> [enable\_aws\_load\_balancer\_controller](#output\_enable\_aws\_load\_balancer\_controller) | The flag for the Load Balancer controller |
| <a name="output_enable_cert_manager"></a> [enable\_cert\_manager](#output\_enable\_cert\_manager) | The flag for Certificate Manager |
| <a name="output_enable_karpenter"></a> [enable\_karpenter](#output\_enable\_karpenter) | The flag for Karpenter |
| <a name="output_enable_metrics_server"></a> [enable\_metrics\_server](#output\_enable\_metrics\_server) | The flag for the Metric Server |
| <a name="output_enable_vpa"></a> [enable\_vpa](#output\_enable\_vpa) | The flag for Virtual Pod Autoscaler |
| <a name="output_platform_teams_configure_kubectl"></a> [platform\_teams\_configure\_kubectl](#output\_platform\_teams\_configure\_kubectl) | The command to use to configure the kubeconfig file to be used with kubectl. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
