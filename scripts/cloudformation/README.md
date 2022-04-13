# CloudFormation Setup

Run GitHubConfiguration.yaml through CloudFormation (https://aws.amazon.com/cloudformation/). This will create a role that GitHub Actions will use to provision resources into your account, as well as an S3 bucket to store Terraform Open Source state files. Make sure you use all lowercase names in the stack name, as we will use it to create an S3 bucket to save your state files.

These commands will require the following utility installed on your system: 
- aws CLI (with proper administrative credentials configured)
- jq 
- openssl
- sed

The best way to run this script is by leveraging the AWS Cloud Shell (note you need to add openssl using `sudo yum install openssl -y` because openssl is not part of the default Cloud Shell package).

> :warning: **This sample template uses AdministratorAccess managed policy and is used for demo purpose only. You should use a more scoped down version of the policy**

First export the `GITHUB_USER` variable with your own GH org/user name (this will point to your own fork of the repo): 
```sh
export GITHUB_USER=<your-github-org-name>
```
Then launch the CFN stack and extract its outputs with these commands:

```sh
# Get the Thumbprint for GitHub OIDC provider
HOST=$(curl -s https://vstoken.actions.githubusercontent.com/.well-known/openid-configuration | jq -r '.jwks_uri | split("/")[2]')

THUMBPRINT=$(echo | openssl s_client -servername $HOST -showcerts -connect $HOST:443 2> /dev/null | sed -n -e '/BEGIN/h' -e '/BEGIN/,/END/H' -e '$x' -e '$p' | tail -n +2 | openssl x509 -fingerprint -noout | sed -e "s/.*=//" -e "s/://g" | tr "ABCDEF" "abcdef")


# Create CloudFormation Stack
aws cloudformation create-stack --stack-name aws-proton-terraform-role-stack \
   --template-body file:///$PWD/GitHubConfiguration.yaml \
   --parameters ParameterKey=FullRepoName,ParameterValue=$GITHUB_USER/eks-blueprints-for-proton \
   ParameterKey=ThumbprintList,ParameterValue=$THUMBPRINT \
   --capabilities CAPABILITY_NAMED_IAM

# Wait for Stack creation to complete
aws cloudformation wait stack-create-complete --stack-name aws-proton-terraform-role-stack

# Get the ARN of the IAM Role created by the stack
aws cloudformation describe-stacks --stack-name aws-proton-terraform-role-stack | jq -r '.Stacks[0].Outputs[] | select(.OutputKey=="Role") | .OutputValue'

# Get the bucket name created by the stack
aws cloudformation describe-stacks --stack-name aws-proton-terraform-role-stack | jq -r '.Stacks[0].Outputs[] | select(.OutputKey=="BucketName") | .OutputValue'
```

Update [`env_config.json`](../../env_config.json) with this Role ARN and BucketName.
