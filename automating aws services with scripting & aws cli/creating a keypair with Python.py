#!/usr/bin/env python3

# loads AWS SDK for Python, called boto
import boto3

# Connect to the Amazon EC2 service
ec2_client = boto3.client('ec2')

# Create a Key Pair
key = ec2_client.create_key_pair(KeyName = 'SDK')

# Print the private Fingerprint of the private key
print(key.get('KeyFingerprint'))

---------------------------------------------------------

# to run script
./create-keypair.py

DELETING KEYPAIRS, AUTOMATICALLY CLEANUP
4 suggestions - dry-run for no accidents, add region support bc default boto3 might not be set, add confirmation prompt before deletion especially in prod,
log or print skipped keys to avoid surprises

#!/usr/bin/env python3

import boto3

# Connect to the Amazon EC2 service
ec2_client = boto3.client('ec2')

# obtains a list of all Key Pairs
keypairs = ec2_client.describe_key_pairs()

for key in keypairs['KeyPairs']: #runs AWS API call to get all key pairs in the region, result is a dictionary []
  if 'lab' not in key['KeyName'].lower():
    print ("Deleting key pair", key ['KeyName'])
    ec2_client.delete_key_pair(KeyName=key['KeyName'])
