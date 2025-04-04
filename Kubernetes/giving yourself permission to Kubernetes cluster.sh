eksctl create iamidentitymapping --cluster nextwork-eks-cluster --arn [USER_ARN] --group system:masters --username admin --region [YOUR-REGION]

# AWS permissions alone don't automatically carry over to Kubernetes
# Kubernetes has its own way of managing access within a cluster even you have Admin Access in AWS
