rm -rf tfekscode
git clone -b module https://github.com/aws-samples/terraform-eks-code.git tfekscode

# clone workshop repo

mv tfekscode environment/

# move file / reorganize them

source ./bootstrap.sh

# setting up a workshop tool above - "helper script"
