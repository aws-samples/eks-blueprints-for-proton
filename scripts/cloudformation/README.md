# CloudFormation Setup

Run GitHubConfiguration.yaml through CloudFormation (https://aws.amazon.com/cloudformation/). This will create a role that GitHub Actions will use to provision resources into your account, as well as an S3 bucket to store our Proton environment's Terraform remote state. Make sure you use all lowercase names in the stack name, as we will use it to create an S3 bucket to save your state files.

These commands will require the following utility installed on your system: 
- AWS CLI (with proper administrative credentials configured)
- jq 
- openssl
- sed

One of the easiest ways to run this script is by leveraging the AWS Cloud Shell (note you need to add openssl using `sudo yum install openssl -y` because openssl is not part of the default Cloud Shell package).

> :warning: **This sample template uses AdministratorAccess managed policy and is used for demo purpose only. You should use a more scoped down version of the policy**

First export the `GITHUB_USER` variable with your own GH org/user name (this will point to your own fork of the repo): 
```sh
export GITHUB_USER=<your-github-org-name>
```
Then launch the CFN stack and extract its outputs by changing into the `scripts/cloudformation` directory and running the following script:

```sh
cd scripts/cloudformation/
./iac.sh
```
