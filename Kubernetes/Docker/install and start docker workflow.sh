sudo yum install -y docker

sudo service docker start
#start docker after installing

docker build -t nextwork-flask-backend .
#then you can build the container image BUT see below

# user accessing instance must have permission to run docker commands
# when installed, it was set up for root user
# no sudo attached, when loggind into EC2 using certain AMIs like Amazon Linux, default user for SSH is a regular user, not a root user
# Docker needs root level access to create containers or build container images

whoami

sudo usermod -a -G docker ec2-user
# adds regular user to Docker group
# Docker group is group in Linux systems that gives users the permission to run Docker commands
# no need type sudo every time, after adding user

# usermod - modifies user's account in the system
# -a flag (append) makes sure user doesn't get removed from other groups, without it user would be removed from all groups not listed
# -G flag specifies the group user should be added to

# REFRESH CONNECTION TO INSTANCE then

groups ec2-user
#check the user's permissions

#run build command again BUT YOU NEED TO CD INTO THE SUBDIRECTORY (folder of cloned github repo)
