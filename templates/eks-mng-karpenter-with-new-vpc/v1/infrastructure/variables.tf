variable "aws_region" {
  description = "AWS region where resources will be provisioned"
  type        = string
  default     = "us-west-2"
}

variable "environment" {
  description = "Map of attributes passed from Proton to Terraform configuration"
  type        = any
}
