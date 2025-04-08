# EBS, block level storage volumes for use with EC2
# EBS snapshots, easy way to backup data stored on EBS volumes
# snapshot can be used to create a new volume if a volume fails or data is accidentally deleted
# should frequently take a snapshot of important volumes

# 1 - copy volume ID of EBS volume
# 2 - run the below terminal command
aws ec2 create-snapshot --description CLI --volume-id YOUR-VOLUME-ID

# snapshots can be easily automated with cron command
