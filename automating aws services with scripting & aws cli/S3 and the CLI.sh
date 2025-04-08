aws s3 mb s3://my-bucket

aws s3 ls

aws s3 ls s3://my-bucket

# cp uploads a file when it is file first ---> bucket second
aws s3 cp file s3://my-bucket/file

# cp downloads a file when it is bucket first <--- file second
aws s3 cp s3://my-bucket/file file

# cp will copy a file between buckets
aws s3 cp s3://bucket1/file s3://bucket2/file

# sync a directory with an S3 bucket
# recursively copies new and updated files from the source directory to the destination
# excellent way to backup data to the cloud
# sync only copies what is not in the destination, or any files that have changed since the last time sync was run
# this makes it easy to perform an incremental backup to S3
aws s3 sync my-directory s3://my-bucket/

# CLI can be installed on any computer
# CLI can be used for
# sending backups to the cloud
# providing shared access to documents from multiple computers
# retrieving scripts and application code from a central repo
# duplicating data between different regions
# commands can be stored in a script and set to operated at a scheduled time by usgin cron command (Linux)
