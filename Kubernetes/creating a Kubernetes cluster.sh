eksctl create cluster \
--name [cluster name] \ # update with cluster name
--nodegroup-name [node group name] \ # update with node group name
--node-type t2.micro \
--nodes 3 \
--nodes-min 1 \
--nodes-max 3 \
--version 1.31 \
--region [region] #update with region
