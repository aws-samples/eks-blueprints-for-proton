# Terraform Setup

Apply this Terraform module to create a role that GitHub Actions will use to provision resources into your account, as well as an S3 bucket to store our Proton environment's Terraform remote state.

This script requires that you have [Terraform installed](https://learn.hashicorp.com/tutorials/terraform/install-cli) as well as proper admin [credentials configured](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#environment-variables).

> :warning: **This sample template uses AdministratorAccess managed policy and is used for demo purpose only. You should use a more scoped down version of the policy**

First export the `GITHUB_USER` variable with your own GH org/user name (this will point to your own fork of the repo): 
```sh
export GITHUB_USER=<your-github-org-name>
```
Then run the script in this directory to use Terraform to provision the resources.

```sh
cd scripts/terraform/
./iac.sh
```

Once this part of the setup is completed, please resume the steps in the main README from [where you left](../../README.md#getting-started-and-one-off-configurations). 
