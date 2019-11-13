#!/bin/bash
#PAYG='https://aws.amazon.com/marketplace/pp/B010GKMEKW'
#BYOL='https://aws.amazon.com/marketplace/pp/B014GECC1A'
#Metered='https://aws.amazon.com/marketplace/pp/B077G9FKK7'

#set the version and build number and then run the script
VERSION='800-0475'

ami_regions=($(aws ec2 describe-regions --output text | sed -e 's/^.*com[[:blank:]]//'))


num_regions=${#ami_regions[@]}

for i in "${ami_regions[@]}"
do
	filter='Name=name,Values=CudaCGFHourly-v'"$VERSION"'*'
	PAYGAMI=$(aws ec2 describe-images --owner aws-marketplace --region $i --filters $filter --query 'Images[-1].{ID:ImageId}' --output text)
	echo "\"$i\" : {"
	echo "    \"Hourly\" : \"$PAYGAMI\","

	filter='Name=name,Values=CudaCGFBYOL-v'"$VERSION"'*'

	BYOLAMI=$(aws ec2 describe-images --owner aws-marketplace --region $i --filters $filter --query 'Images[-1].{ID:ImageId}' --output text)
	echo "    \"BYOL\" : \"$BYOLAMI\","

	filter='Name=name,Values=CudaCGFMetered*v'"$VERSION"'*'

	METEREDAMI=$(aws ec2 describe-images --owner aws-marketplace --region $i --filters $filter --query 'Images[-1].{ID:ImageId}' --output text)
	echo "    \"Metered\" : \"$METEREDAMI\""
	if [[ $i == ${ami_regions[${#ami_regions[@]}-1]} ]]
	then
		echo "}"
	else
        	echo "},"
	fi

done
