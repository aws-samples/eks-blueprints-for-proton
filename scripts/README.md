# Core Resources

In order to provision our Proton environments via Terraform from within Github Actions, we'll need to provision two core resources up front.

1. IAM Identity Provider and an IAM Role used by Github Actions to authenticate with AWS and run Terraform.

2. S3 Bucket to serve as our Terraform [remote state backend](https://www.terraform.io/language/state/remote).


We have provided infrastructure as code to provision these core resources in both Terraform and CloudFormation.  Feel free to use whichever you prefer.

- [Terraform](./terraform/README.md)

- [CloudFormation](./cloudformation/README.md)
