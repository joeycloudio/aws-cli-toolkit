#dumps all available methods for EC2 client
import boto3
ec2 = boto3.client('ec2')
print(dir(ec2))

# tells you all the args it takes
help(ec2.describe_instances)
