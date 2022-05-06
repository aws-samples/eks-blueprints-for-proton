/*
This file is no longer managed by AWS Proton. The associated resource has been deleted in Proton.
*/

variable "aws_region" {
  type    = string
  default = "us-west-1"
}

variable "environment_for_local_test" {
  type = object({
    inputs = object({
      kubernetes_version           = any
      cluster_name                 = any
      vpc_cidr                     = any
      user                         = any
      aws_load_balancer_controller = any
      metrics_server               = any
      aws_for_fluentbit            = any
      cert_manager                 = any
      vpa                          = any
      karpenter                    = any
    })
  })
  default = {
    inputs = {
      kubernetes_version           = "1.21"
      cluster_name                 = "proton-blueprint-cluster"
      vpc_cidr                     = "10.0.0.0/16"
      user                         = "<user>"
      aws_load_balancer_controller = true
      metrics_server               = true
      aws_for_fluentbit            = true
      cert_manager                 = true
      vpa                          = true
      karpenter                    = true
    }
  }
}