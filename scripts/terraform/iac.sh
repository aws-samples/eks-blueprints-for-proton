#!/bin/bash
set -e
terraform init
TF_VAR_github_org=$GITHUB_USER \
TF_VAR_github_repo=eks-blueprints-for-proton \
   terraform apply -auto-approve
