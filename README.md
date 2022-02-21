# eks-blueprint-proton-template

EKS Blueprint Proton template repository

Welcome! This repository should help you test how AWS Proton works with Terraform Open Source to provision your Amazon EKS infrastructure. In this repository you will find three things:

1. A CloudFormation [template](scripts/cloudformation/GitHubConfiguration.yamlGitHubConfiguration.yaml) that will help you get the underlying roles and permissions set up and an S3 bucket created to hold your Terraform state.
1. A GitHub Actions task to run Terraform Open Source based on commits to this repo
1. An Amazon EKS [example](templates/eks-mng-karpenter-with-new-vpc/v1/infrastructure) based on [Amazon EKS Acclerator](https://github.com/aws-samples/aws-eks-accelerator-for-terraform)  

## How to

1. Fork this repository into your GitHub account
2. We will be using Github Actions to deploy our Terraform template, and notify Proton of the deployment status. You can see the steps of our workflow in [proton_run.yml](.github/workflows/proton-run.yml) and [terraform.yml](.github/workflows/terraform.yml). Forked repositories do not have Actions enabled by default, see [this page](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/enabling-features-for-your-repository/managing-github-actions-settings-for-a-repository) for information on how to enable them.
3. Ensure you have a CodeStar Connection set up for the account into which you forked the repo in the previous step. For information on how to set that up see this [documentation](https://docs.aws.amazon.com/dtconsole/latest/userguide/connections-create.html).
4. Run `GitHubConfiguration.yaml` through [CloudFormation](https://aws.amazon.com/cloudformation/) by following the [instructions](scripts/cloudformation/README.md). This will create a role that GitHub Actions will use to provision resources into your account, as well as an S3 bucket to store Terraform Open Source state files.
5. Open the file [env_config.json](env_config.json). Add a new object to the configuration dictionary where the `key` is ENVIRONMENT_NAME, `role` is the Role output from the stack created in (4), the `region` with AWS_REGION and `bucket` is the s3 bucket create in (3). You can use different roles for each environment by adding them to this file.
6. Commit your changes and push them to your forked repository.
7. Create a Proton Environment Template by following the steps outlined in the [documentation](https://docs.aws.amazon.com/proton/latest/adminguide/ag-templates.html). You can use Tempalte [Sync](https://docs.aws.amazon.com/proton/latest/adminguide/ag-template-sync-configs.html) to automatically detect changes in your environment templates.
8. Create a Proton Environment following the [documentation](https://docs.aws.amazon.com/proton/latest/adminguide/ag-environments.html).
9. Shortly after you trigger the deployment, come back to your repository to see the Pull Request. Once you merge it, you can go back to Proton and see the updated status of your newly created environment.
