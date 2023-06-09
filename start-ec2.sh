instance_id='i-0456c30d3ffd6aad3'
region='ap-south-1'
aws --version
echo "EC2 Instance Id : $instance_id"
echo "  --> Fetching Instance $instance_id status."
aws ec2 describe-instance-status --region $region --instance-id $instance_id
instance_state=$(aws ec2 describe-instance-status --region $region --instance-id $instance_id --query 'InstanceStatuses[*].InstanceState.Name' --output text)
size=${#instance_state}
echo "Instance Status : $instance_state"
echo "Instance Size : $size"
if [ -z "$instance_state" ]
then
echo "  --> Instance $instance_id is not in running state. Starting the instance"
# on first execution start-instances command returns "pending" state.
# we can run small while loop to check if instance started successfully or not
instance_start_invoke=$(aws ec2 start-instances --region $region --instance-ids $instance_id --query 'StartingInstances[*].CurrentState.Name' --output text)
echo "  --> start instance command execution result : $instance_start_invoke"
if [ "$instance_start_invoke" = "pending" ]
then
fetch_instance_start=$instance_start_invoke
while [ "$fetch_instance_start" = "pending" ]
do
fetch_instance_start=$(aws ec2 start-instances --region $region --instance-ids $instance_id --query 'StartingInstances[*].CurrentState.Name' --output text)
echo "  --> Instance state : $fetch_instance_start"
sleep 5
done
echo "  --> -------------------------------------------"
echo "  --> Instance state : $fetch_instance_start"
echo "  --> Checking Instance Health status"
fetch_instance_health="initializing"
while [ "$fetch_instance_health" = "initializing" ]
do
fetch_instance_health=$(aws ec2 describe-instance-status --region $region --instance-id $instance_id --query 'InstanceStatuses[*].InstanceStatus.Status' --output text)
echo "  --> Instance health check : $fetch_instance_health"
sleep 10
done
echo "  --> -------------------------------------------"
echo "  --> Instance health : $fetch_instance_health"
echo "Fetching Instance Ip"
instance_ip=$(aws ec2 describe-instances --region $region --instance-id $instance_id --query "Reservations[*].Instances[*].PublicIpAddress" --output=text)
fi
fi
