# CloudFormation Setup

Run `GitHubConfiguration.yaml` through CloudFormation (https://aws.amazon.com/cloudformation/). This will create an IAM role that GitHub Actions will use to provision resources into your account, as well as an S3 bucket to store our Proton environment's Terraform remote state. Make sure you use all lowercase names in the stack name, as we will use it to create an S3 bucket to save your state files.

We have provided a script that launches the CFN Stack. This script will require the following utility installed on your system: 
- AWS CLI (with proper administrative credentials configured)
- jq 
- openssl
- sed

One of the easiest ways to run this script is by leveraging the AWS Cloud Shell (note you need to add `openssl` using `sudo yum install openssl -y` because openssl is not part of the default Cloud Shell packages available).

> :warning: **This sample template uses AdministratorAccess managed policy and is used for demo purpose only. You should use a more scoped down version of the policy**

First, clone your forked repo (for me it's `git clone https://github.com/mreferre/eks-blueprints-for-proton`) and then export the `GITHUB_USER` variable with your own GH org/user name (this will point to your own fork of the repo): 
```sh
export GITHUB_USER=<your-github-org-name>
```
Then launch the CFN stack and extract its outputs by changing into the `scripts/cloudformation` directory and running the following script (remember to install the `openssl` package before you run it if you are using Cloud Shell):

```sh
cd eks-blueprints-for-proton/scripts/cloudformation/
./iac.sh
```

Once this part of the setup is completed, please resume the steps in the main README from [where you left](../../README.md#getting-started-and-one-off-configurations). 