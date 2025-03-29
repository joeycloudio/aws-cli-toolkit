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
