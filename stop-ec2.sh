echo "  --> Run Command in EC2: docker-compose -f docker-compose-grid4-ec2.yml down -d"
echo "  --> Remove docker-compose-grid4-ec2.yml file"
echo "  --> Stop EC2 Instance"
region='ap-south-1'
aws ec2 stop-instances --instance-ids i-0456c30d3ffd6aad3 --region $region
