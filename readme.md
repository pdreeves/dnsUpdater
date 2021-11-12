# dnsUpdater

## Overview
This is a little container to keep an [AWS Route53](https://aws.amazon.com/route53/) record updated based on the public IP of the host running this container.  The idea is to use this in have a DNS A-record that is up-to-date with my public IP address, so that I can use this record in DNS-based firewall rules and route traffic back to my firewall/router.

There are two components:
- AWS CloudFormation template: contains the necessary AWS resources to create a user to manage and list the relevant DNS records in route53.
- Docker container: Basically a fancy cron script to check to see if any DNS records need updating, and update them if they need to be.

## Deployment
- Deploy AWS CloudFormation template
	- Can be done via AWS Console
	- AWS CLI: `aws cloudformation create-stack --stack-name dnsUpdater-cfn --capabilities CAPABILITY_NAMED_IAM --template-body file://cloudFormation.yml --parameters ParameterKey=dnsZoneID,ParameterValue={{ dnsZoneID }}`
- Create credentials for the new AWS account that was created: 
	- Can be done via AWS Console
	- AWS CLI: `aws iam create-access-key --user-name dnsUpdater-iam-user`
- Create container: `docker image build . --file Dockerfile --tag dnsupdater`
- Schedule container as cron task: `sudo echo ' * 11 * * * docker run --rm -e AWS_ACCESS_KEY_ID={{ awsAccessKey }} -e AWS_SECRET_ACCESS_KEY={{ awsSecretKey }} -e AWS_DEFAULT_REGION={{ awsRegion }} -e awsHostedZoneID={{ dnsZoneID }} -e route53RecordName={{ route53RecordName }} dnsupdater' > /etc/crontab/root `


## Helpful commands
- Run contaienr manually: `docker run --rm -e AWS_ACCESS_KEY_ID={{ awsAccessKey }} -e AWS_SECRET_ACCESS_KEY={{ awsSecretKey }} -e AWS_DEFAULT_REGION={{ awsRegion }} -e awsHostedZoneID={{ dnsZoneID }} -e route53RecordName={{ route53RecordName }} dnsupdater`