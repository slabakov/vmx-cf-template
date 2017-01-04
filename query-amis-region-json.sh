id=$1 # AMI id as input

type=image # or "instance" or "volume" or "snapshot" or ...

regions=$(aws ec2 describe-regions --output text --query 'Regions[*].RegionName')
for region in $regions; do
    (
     aws ec2 describe-${type}s --region $region --$type-ids $id &>/dev/null && 
         echo "\"$region\": { " &&
         echo "    \"AWSVMX\": \"$id\"" &&
         echo "}," 
    ) &
done 2>/dev/null; wait 2>/dev/null
