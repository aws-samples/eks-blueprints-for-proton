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
