
## WORK IN PROGRESS (do not review for now)

#### What is the goal of this tutorial?

This repository includes a template example to configure AWS Proton as a vending machine for EKS cluster using Terraform. For more information about this use case please read this [blog post](). This tutorial is not intended to be used as-is for production. It provides an example of how to use Proton for this specific scenario. 

#### Getting started and one-off configurations 

To get started with this tutorial you need to have an AWS account with administrative privileges and a GitHub account. 

> Note: Terraform provisioning happens outside the context of Proton and for that we are providing a sample GitHub action as part of the same repository. However, you could use any pipeline you want to accomplish the same result with a similar flow.

Login to the AWS console and select the AWS region where you want to exercise this tutorial.  

Create a repository (in your GitHub account) off of this template: https://github.com/aws-samples/eks-blueprints-for-proton and keep the same name (you can also fork the repository if you prefer).    

Set up an AWS CodeStar connection following [these instructions](https://docs.aws.amazon.com/proton/latest/adminguide/setting-up-for-service.html#setting-up-vcontrol). This will allow you to access your GitHub account (and your repos) from Proton.

Go to the Proton console and switch to the `Settings/Repositories` page. Add the repository you created/forked above. It should look something like this: 

![proton_registry](proton_registry.png)

For Terraform to be able to deploy/vend clusters, it needs to assume a proper IAM role. In addition, since for our solution we will use Terraform open source, we also need an S3 bucket to save the Terraform state. To do this please follow the instructions [at this page](./scripts/cloudformation/README.md).   

> The above is a one-off CFN stack we use to create an IAM role and S3 bucket. If you are vested in Terraform and want to use Terraform to create these two objects it's perfectly fine. 

Retrieve the role ARN and the S3 bucket name from the stack above and update the [env-config.json](./env_config.json) file in your GitHub repository. Make sure to update the `region` parameter to the region you are using. 

Create two IAM users that you will be using to mimic the `platform administrator` and the `developer`: 
- `protonadmin` (with the AWS managed `AWSProtonFullAccess` policy)
- `protondev` (with the AWS managed `AWSProtonDeveloperAccess` policy)

Because in Proton a developer, with the standard `AWSProtonDeveloperAccess`, is not allowed to deploy an environment, you need to add this inline policy to the `protondev` user: 
```aidl
inline policy
```

#### Create the environment template in Proton

Now that you configured the core requirements in your accounts, login as `protonadmin` in the console and create the environment template that Proton will use to vend clusters. 

Switch to the `Templates/Environment templates` page in the Proton console and click `Create environment template`. In the `Template bundle source` select `Sync templates from Git`. Pick the repository in your account, set the Branch name to main. In the Template details set `eks-mng-karpenter-with-new-vpc` as the `Template name`.

> It is important that you set the name exactly to `eks-mng-karpenter-with-new-vpc` because Proton will scan the repo for that exact folder name (and version structure).

Set a `Template display name` for convenience, leave everything else as default and click `Create environment template`.

Within a few seconds you should see a template version `1.0` appear. It's in `Draft` state. Click `Publish` and it will move into `Published` state.

You should see something like this:

#### Deploy the cluster via Proton

Now that a platform administrator has configured the template that represents the organization standard for an EKS cluster, logout from the console and login with the `protondev` user. 

Navigate to the `Environments` page in Proton and click `Create environment`. Select the environment template you created above and click `Configure`. In the `Provisioning` section select `Self-managed provisioning`. In the `Provisioning repository details` select `GitHub`, in `CodeStar connection` select your GitHub account, in the `Repository name` select the GitHub repo you create above and `main` as the `Branch name`. Provide an `Environment name` and an `Environment description` of your choice and click `Next`.

You should now see something like this:

PICTURE 

This is where the magic starts to happen. The input parameters you see here (which are obviously related to the EKS cluster you are about to provision) are part of the sample template provided in the repo but that you can fully customize based on your needs. Specifically the [main.tf](https://github.com/aws-samples/eks-blueprints-for-proton/blob/main/templates/eks-mng-karpenter-with-new-vpc/v1/infrastructure/main.tf) file is where the [EKS Blueprints](https://github.com/aws-ia/terraform-aws-eks-blueprints/blob/main/docs/getting-started.md) module is imported and where the core configuration is defined. The [schema.yaml](https://github.com/aws-samples/eks-blueprints-for-proton/blob/main/templates/eks-mng-karpenter-with-new-vpc/v1/schema/schema.yaml) file is where all the inputs get defined. Note that in the template sample we created in the repo the only Kubernetes version you can pick is 1.21 because we pretend that this is the only version that the platform team at your org has vetted and is supporting internally. 

Give your cluster a name, leave the vpc_cidr as is and add your AWS IAM user (`protondev`) to the input `user`. The EKS Blueprints will enable the user you enter to assume an IAM role that has been defined a Kubernetes cluster admin in the K8s RBAC. At your discretion, and based on your potential needs, enable or disable the add-ons available.    

Click `Next` and in the next summary form click `Create`. This will trigger your cluster creation. 

This will cause the following events to trigger:
- Proton will merge the Terraform template with your inputs and create a PR in the repository you specified (in our tutorial it's the same repository that hosts the template, but you probably want these to be two separate repositories in a production setup - just remember to add them both to the Proton `Repositories` page you configured at the beginning)
- The GitHub action will trigger to run a plan and check everything is in good shape 
- The PR will be merged (this can be a manual step performed by a platform administrator or because Proton creates enough guardrails for the PR to be legit, the repository can be configured to perform an auto-merge)
- Once the PR is merged the GH action provided as an example in the repository will kick off again and this time it will go till the `terraform apply` stage effectively deploying the cluster 
- When the `apply` has completed the action will notify Proton with the `output` which consists of the `eks aws` command to configure the `config` file to point `kubectl` to the cluster you just deployed. 

> Note: if you want to know more about how Terraform templating and Git provisioning works in Proton, please refer to these two blogs posts: [AWS Proton Terraform Templates](https://aws.amazon.com/blogs/containers/aws-proton-terraform-templates/) and [AWS Proton Self-Managed Provisioning](https://aws.amazon.com/blogs/containers/aws-proton-self-managed-provisioning/). 

In other words, you should see something like this in your Proton console for the environment you have just deployed: 

PICTURE 

If you are still logged in as `protondev` and you open a Cloud Shell, you can run the command as reported in the Proton output and configure your shell to communicate with this cluster. If you have `kubectl` installed in your shell you can start interacting with the cluster: 

```aidl









```

Congratulations. You have just witnessed Proton vending an EKS cluster.

#### Updating the Proton cluster template

As a platform administrator you may get to the point where you bless another Kubernetes version. In this case let's simulate that you have verified K8s version `1.22` adheres to your organization standards, and you want to make it available to you developers. The only thing you need to do is to update the [schema.yaml](https://github.com/aws-samples/eks-blueprints-for-proton/blob/main/templates/eks-mng-karpenter-with-new-vpc/v1/schema/schema.yaml) file in your own repository (the repository you are using with Proton) to include the new version. Specifically you need to configure the `kubernetes_version` variable to accept both `1.21` and `1.22` and change the default to `1.22` as follows: 
```aidl
        kubernetes_version:
          type: string
          description: Kubernetes Version
          enum: ["1.21", 1.22]
          default: "1.22"
```

When you push this commit to your repository in GitHub, Proton will detect the change in the template. If you login with your `protonadmin` user you will see in the details of your `Environment template` that there is a new version in the `Draft` stage. You can click `Publish`, and it will become the new default minor version for that template. 

This means that every cluster a developer will deploy with this template can be deployed with either versions (because `1.21` and `1.22` are both valid options). However, it is also possible to upgrade an existing 1.21 cluster to the new 1.22 version. 

#### Updating an existing cluster

Now that a Proton administrator have updated the template, login back as the `protondev` user and open your Proton environment that represents the cluster you deployed above. You will notice that there is a message that says that there is a new template available. You can now `Update` your environment to apply the new template: 

PICTURE 







A good way to make the deployment fail and WATCH the NOTIFY PROTON job not kicking in: use `/Admin/mreferre-Isengard` as the user-name to add as an admin in the environment deployment workflow. This will cause the apply to fail with:
failed creating IAM Role (efe5-aws001-preprod-dev-platform-team-Access): MalformedPolicyDocument: Invalid principal in policy: "AWS":"arn:aws:iam::***:user/Admin/mreferre-Isengard"








User is required. Do we make it optional (for real) or do we make it mandatory? Optional would be better IMO.








The fact that the cluster disappears immediately from Proton is an issue


 