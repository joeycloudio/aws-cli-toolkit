./show-credentials

# data about your instance that you can use to config and manage the running instance
# a set of security credentials is included in the data and used for all commands in lab

# worked as follows
# role named scripts was created with appropriate permissions to run the lab
# EC2 instance that was used was launched with the scripts role
# AWS CLI and Python SDK automatically retrieved the security credentials via Instance Metadata Service

# this is an example of role-based access (ec2 with an attached role) vs key-based access (locally)
# this is only availabe with EC2
