eksctl create cluster \
--name [cluster name] \ # update with cluster name
--nodegroup-name [node group name] \ # update with node group name
--node-type t2.micro \
--nodes 3 \ #Start your node group with 3 nodes and automatically scale between 1 (minimum) and 3 nodes (maximum) based on demand.
--nodes-min 1 \
--nodes-max 3 \
--version 1.31 \ #Use Kubernetes version 1.31 for the cluster setup.
--region [region] #update with region

# EKS charges $0.10 for every hour your cluster is running.
