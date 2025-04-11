REGION="eu-west-2"; echo "== EC2 INSTANCES ==" && aws ec2 describe-instances --region $REGION --query 'Reservations[*].Instances[*].{ID:InstanceId,State:State.Name,Type:InstanceType,AZ:Placement.AvailabilityZone}' --output table && echo "== EBS VOLUMES ==" && aws ec2 describe-volumes --region $REGION --query 'Volumes[?State==`in-use`].[VolumeId,Size,AvailabilityZone]' --output table && echo "== ELBs ==" && aws elb describe-load-balancers --region $REGION --output table && aws elbv2 describe-load-balancers --region $REGION --output table && echo "== S3 BUCKETS ==" && aws s3api list-buckets --query 'Buckets[*].Name' --output table && echo "== EKS CLUSTERS ==" && aws eks list-clusters --region $REGION --output table && echo "== RDS INSTANCES ==" && aws rds describe-db-instances --region $REGION --query 'DBInstances[*].{ID:DBInstanceIdentifier,Status:DBInstanceStatus,Class:DBInstanceClass}' --output table && echo "== LAMBDAS ==" && aws lambda list-functions --region $REGION --query 'Functions[*].{Function:FunctionName,Runtime:Runtime}' --output table && echo "== CLOUDFORMATION STACKS ==" && aws cloudformation list-stacks --region $REGION --stack-status-filter CREATE_COMPLETE UPDATE_COMPLETE --query 'StackSummaries[*].{Name:StackName,Status:StackStatus}' --output table

# for Linux
aws ce get-cost-and-usage \
  --time-period Start=$(date -d "-3 days" +%Y-%m-%d),End=$(date +%Y-%m-%d) \
  --granularity DAILY \
  --metrics "UnblendedCost" \
  --output table

  # for macOS
  aws ce get-cost-and-usage \
  --time-period "{\"Start\":\"$(date -v -3d +%Y-%m-%d)\",\"End\":\"$(date +%Y-%m-%d)\"}" \
  --granularity DAILY \
  --metrics "UnblendedCost" \
  --output table

aws ce get-cost-and-usage \
  --time-period "{\"Start\":\"$(date -v -3d +%Y-%m-%d)\",\"End\":\"$(date +%Y-%m-%d)\"}" \
  --granularity DAILY \
  --metrics "UnblendedCost" \
  --group-by Type=DIMENSION,Key=SERVICE \
  --output table

# total costs over the last 5 days
# change granularity from daily to monthly
# set the day range to 5 days
aws ce get-cost-and-usage \
  --time-period "{\"Start\":\"$(date -v -5d +%Y-%m-%d)\",\"End\":\"$(date +%Y-%m-%d)\"}" \
  --granularity MONTHLY \
  --metrics "UnblendedCost" \
  --group-by Type=DIMENSION,Key=SERVICE \
  --output table
