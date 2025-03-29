sudo yum install -y docker

sudo service docker start
#start docker after installing

docker build -t nextwork-flask-backend .
#then you can build the container image
