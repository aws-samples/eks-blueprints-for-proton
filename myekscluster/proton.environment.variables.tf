/*
This file is no longer managed by AWS Proton. The associated resource has been deleted in Proton.
*/

variable "environment" {
  type = object({
    inputs = map(string)
    name   = string
  })
  default = null
}