# easiest way to save money is to turn off unused EC2 instances
# can be triggered by cron
# if it finds instances with a specific tag, either stops or terminates them

#!/usr/bin/env python3

import boto3

# Connect to the Amazon EC2 service
ec2 = boto3.resource('ec2')

# Loop through each instance
for instance in ec2.instances.all():
  state = instance.state['Name']
  for tag in instance.tags:

    # Check for the 'stopinator' tag
    if tag['Key'] == 'stopinator':
      action = tag['Value'].lower()

      # Stop?
      if action == 'stop' and state == 'running':
        print ("Stopping instance", instance.id)
        instance.stop()

      # Terminate?
      elif action == 'terminate' and state != 'terminated':
        print ("Terminating instance", instance.id)
        instance.terminate()

# add tag with key "stopinator" and value "stop"
# then modify tag with value "terminate"

additional ideas
----------------
# schedule to stop instances every night
# mark instances you want to keep running, then have stopinator stop only unknown instances (but don't terminate since they may be important)
# create another script that turns them on in the morning
# set different actions for weekdays and weekends
# use another tag to identify how many hours you want instance to run (for experiments), schedule stopinator to run hourly and configure to terminate instances that run longer than the indicated number of hours
