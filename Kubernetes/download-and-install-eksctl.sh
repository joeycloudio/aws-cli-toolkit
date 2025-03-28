curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv -v /tmp/eksctl /usr/local/bin

---------------------------------------------
# downloads latest eksctl from GitHub
# second command moves it to a directory that lets you run eksctl from anywhere in your terminal

# installed this onto our ec2 server
