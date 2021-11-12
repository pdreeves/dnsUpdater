#!/bin/sh

# Retrieve current IP address
currentIP=$(curl https://api.ipify.org)

# Retrieve IP from route53
ipFromRoute53=$(nslookup $route53RecordName | grep 'Address' | tail -1 | awk '{print $2'})

# Get current date
currentDate=`date`

# If the currentIP != ipFromRoute53...
if [ "$currentIP" != "$ipFromRoute53" ]; then
	# Update route53 DNS record to match currentIP
	aws route53 change-resource-record-sets --hosted-zone-id $awsHostedZoneID --change-batch '{ "Changes": [ { "Action": "UPSERT", "ResourceRecordSet": { "Name": "'$route53RecordName'", "Type": "A", "TTL": 300, "ResourceRecords": [ { "Value": "'$currentIP'" } ] } } ]}'
	# Log to stdout
	echo "$currentDate update=true currentIP=$currentIP ipFromRoute53=$ipFromRoute53"
else
	# Log to stdout
	echo "$currentDate update=false currentIP=$currentIP ipFromRoute53=$ipFromRoute53"
fi