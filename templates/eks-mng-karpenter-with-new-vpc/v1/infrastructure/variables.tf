variable "aws_region" {
  type    = string
  default = "us-west-1"
}

variable "environment" {
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
      kubernetes_version           = "1.22"
      cluster_name                 = "proton-test-cluster"
      vpc_cidr                     = "10.0.0.0/16"
      user                         = "eks-admin"
      aws_load_balancer_controller = true
      metrics_server               = true
      aws_for_fluentbit            = true
      cert_manager                 = true
      vpa                          = true
      karpenter                    = true
    }
  }
}
