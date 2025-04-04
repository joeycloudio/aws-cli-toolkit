BASIC SETUP - 

rm -rf tfekscode
git clone -b module https://github.com/aws-samples/terraform-eks-code.git tfekscode
# clone workshop repo

SETUP WORKSHOP TOOLS - 

mv tfekscode environment/
# move file / reorganize them

source ./bootstrap.sh
# setting up a workshop tool above - "helper script"

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
