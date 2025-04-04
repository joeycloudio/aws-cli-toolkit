rm -rf tfekscode
git clone -b module https://github.com/aws-samples/terraform-eks-code.git tfekscode
# clone workshop repo

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
