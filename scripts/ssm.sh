#!/bin/bash

if [[ $# -eq 0 ]]; then
    echo "Yoh Dawg! I'm gonna need an instance name to connect to"
    exit 1
fi

InstanceName=$1

TargetInstanceId=$(aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" "Name=tag:Name,Values=$InstanceName" --profile twp --region us-west-1 --no-paginate | jq -r '.Reservations[0].Instances[0].InstanceId')

aws ssm start-session --profile twp --region us-west-1 --target $TargetInstanceId
