# EBS, block level storage volumes for use with EC2
# EBS snapshots, easy way to backup data stored on EBS volumes
# snapshot can be used to create a new volume if a volume fails or data is accidentally deleted
# should frequently take a snapshot of important volumes

# 1 - copy volume ID of EBS volume
# 2 - run the below terminal command
aws ec2 create-snapshot --description CLI --volume-id YOUR-VOLUME-ID

# snapshots can be easily automated with cron command

# each time a snapshot is made, you will accuumulate more
# but may want to only keep few recent ones
# best solution is a script that removes old snapshots

-----------
WITH PYTHON
-----------

#!/usr/bin/env python3

import boto3
import datetime

MAX_SNAPSHOTS = 2   # Number of snapshots to keep

# Connect to the Amazon EC2 service
ec2 = boto3.resource('ec2')

# Loop through each volume
for volume in ec2.volumes.all():

  # Create a snapshot of the volume with the current time as a Description
  new_snapshot = volume.create_snapshot(Description = str(datetime.datetime.now()))
  print ("Created snapshot " + new_snapshot.id)

  # Too many snapshots?
  snapshots = list(volume.snapshots.all())
  if len(snapshots) > MAX_SNAPSHOTS:

    # Delete oldest snapshots, but keep MAX_SNAPSHOTS available
    snapshots_sorted = sorted([(s, s.start_time) for s in snapshots], key=lambda k: k[1])
    for snapshot in snapshots_sorted[:-MAX_SNAPSHOTS]:
      print ("Deleted snapshot " + snapshot[0].id)
      snapshot[0].delete()
