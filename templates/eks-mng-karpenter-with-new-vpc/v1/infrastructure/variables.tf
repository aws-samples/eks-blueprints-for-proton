variable "aws_region" {
  description = "AWS region where resources will be provisioned"
  type        = string
  default     = "us-east-1"
}

# Proton creates the variable definition for this variable and therefore it should not be included
# in this variable definition file.
# See https://docs.aws.amazon.com/proton/latest/userguide/ag-infrastructure-tmp-files-terraform.html#compiled-tform
# variable "environment" {
#   description = "Map of attributes passed from Proton to Terraform configuration"
#   type        = any
# }
