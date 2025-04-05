BASIC SETUP - 

rm -rf tfekscode
git clone -b module https://github.com/aws-samples/terraform-eks-code.git tfekscode
# clone workshop repo

SETUP WORKSHOP TOOLS - 

mv tfekscode environment/
# move file / reorganize them

source ./bootstrap.sh
# setting up a workshop tool above - "helper script"
# likely installed terraform here and CLI tools, jq, kubectl, terraform, etc.
# set ups environment variables

Ctrl + C
# needed to stop command due to aws configure not set

aws configure

source ~/.bashrc
# ran after aws configure and source ./bootstraph.sh

console step - create IAM admin role for EC2, attached to EC2

SETUP AWS HOSTS ALIAS FOR DNS LATER IN LAB

export TF_VAR_awsalias=eks.workshop.local # eks.workshop.local was used as a placeholder
echo "export TF_VAR_awsalias=${TF_VAR_awsalias}" | tee -a ~/.bashrc
source ~/.bashrc #reloads current shell configuration without having to log out and back in, it's a script that runs every time you open a new terminal, sets ups env variables (region), aliases, paths, etc.

CHECKS MADE -

./check # script designed for workshop
# used manual checks instead

aws sts get-caller-identity
aws ec2 describe-instances --region eu-west-2
#IAM role and CLI are working correctly

aws ec2 describe-vpcs --filters Name=isDefault,Values=true --region eu-west-2
aws ec2 describe-internet-gateways --region eu-west-2
#checking lab default VPC was actually created since we are adpating this

INITIAL TERRAFORM SETUP TO CREATE THE TF STATE BUCKET (PART 1 OF 8)
cd ~/environment/tfekscode/tf-setup
terraform init
terraform validate # should say success! the configuration is valid
terraform plan -out tfplan # plan the deployment

export AWS_REGION=eu-west-2
export TF_VAR_region=eu-west-2
# had to set environment variables for terraform because it was going to create resources in the wrong region

terraform apply tfplan

Apply complete! Resources: 27 added, 0 changed, 0 destroyed.

Outputs:

keyid = "ac6f6968-6473-4dd0-abcb-20ab60761127"
region = [
  "eu-west-2",
]
s3_bucket = [ #S3 bucket for storing remote state
  "tf-state-workshop-d9cf288fe27e1712",
]
tfid = "d9cf288fe27e1712"

aws ssm describe-parameters --query "Parameters[].Name" --output json | jq -r '.[]'
# how to see the SSM parameters being stored at this point of the build
# tf state file metadata, env variables, EKS cluster settings, random project IDs
# why? centralized and version-controlled method
aws ssm get-parameter --name "/workshop/tf-eks/cluster-name"
aws ssm get-parameter --name /workshop/tf-eks/grafana-id --query Parameter.Value --output text
#to check parameters stored specifically, two ways to do that above

CHANGED # region in vars-main.tf
grep -r "eu-west-1" . # RECURSIVELY SEARCHES EVERY FILE IN THE CURRENT FOLDER FOR THE STRING
# period (.) means current directory downward
# find every mention in entire project folder, no matter where it's nested
# will return a lot of output

cd ~/environment/tfekscode/net
terraform init

grep 'version' *.tf
# run in "net" folder because there was a problem with the version
# only searches *.tf filed in current directory because it's not recursive
# won't catch subdirectories

FIX TO GET TF TO INIT TO DEPLOY THE NETWORK & EKS CLUSTER CREATION
find . -type f -name "*.tf" -exec sed -i '/source *= *"hashicorp\/aws"/,/}/s/version *= *".*"/version = "5.30.0"/' {} +
find . -type f -name "*.tf" -exec sed -i '/source *= *"hashicorp\/aws"/,/}/s/version *= *".*"/version = "5.30.0"/' {} +
# replaces all locations that don't have version "5.30.0" set - worked, when ran in cluster file
find . -type f -name "*.tf" -exec sed -i '/source *= *"hashicorp\/aws"/,/}/s/version *= *"[^"]*"/version = ">= 5.30.0"/' {} +

# Set all aws provider version blocks to a clean value

rm -rf .terraform .terraform.lock.hcl
rm -rf .terraform .terraform.lock.hcl
# Clean out old state and modules
# removes recursively (delete directories and everything inside them) and f means force (don't prompt for confirmation) 
# deletion of terraform working directory that holds downloaded provider plugins and modules and the 
# provider lock file (pins specific versions of providers)

terraform init -upgrade -reconfigure
terraform init -upgrade -reconfigure
# Reinitialize Terraform cleanly
terraform validate
terraform plan -out tfplan
terraform apply tfplan
aws ssm describe-parameters --query "Parameters[].Name" --output json | jq -r '.[]' # lists of parameter stores
aws ssm get-parameter --name /workshop/tf-eks/eks-version --query Parameter.Value --output text # paramater of a specific parameter store

rm -rf .terraform .terraform.lock.hcl

terraform init -upgrade -reconfigure

grep -r 'source *= *"hashicorp/aws"' -A 2 .
# returned 'source *= *"hashicorp/aws"' and 2 lines after that

EKS CLUSTER:
cd ~/environment/tfekscode/cluster
terraform init
terraform validate
terraform plan -out tfplan
terraform apply tfplan

VALIDATING AND TESTING COMPONENTS
aws eks update-kubeconfig --name eks-workshop --region eu-west-2
kubectl get nodes
kubectl get pods -n kube-system
kubectl get pods -n amazon-cloudwatch
kubectl get pods -n karpenter
