#!/bin/bash

function cache_aws_instances {
    cache_file=$1

    echo "Caching instances to $cache_file"

    instances=$(aws ec2 describe-instances --profile twp --region us-west-1 |
        jq '[.Reservations | .[] | .Instances | .[] | select(.State.Name == "running") | {Name: (.Tags[]|select(.Key=="Name") | .Value), InstanceId: .InstanceId} ]')

    echo $instances | jq -r 'map("\(.Name) :: \(.InstanceId)") | .[]' > $cache_file
}

function get_cache_file {
    prefix="jasuba.ec2.instances"

    cache_dir=$(ls "/tmp/" | grep $prefix | head -n 1)

    if [[ ! -z $cache_dir ]]; then
        echo "/tmp/$cache_dir"
    else
        echo $(mktemp $prefix"XXXXX" --tmpdir)
    fi
}

cache_file=$(get_cache_file)

if [[ -s $cache_file ]]; then
    # Cache File Exists and is NOT empty
    selected_instance=$(cat $cache_file | fzf)
else
    echo "Cache File Empty: Fetching EC2 instances"

    cache_aws_instances "$cache_file"

    selected_instance=$(cat $cache_file | fzf)
fi

option=$1
TargetInstanceId=$(echo $selected_instance | cut -d ':' -f 3 | xargs)

if [[ "p" == "$option" ]]; then
    # start port forwarding session on port 22
    aws ssm start-session --region us-west-1 --profile twp \
        --document-name AWS-StartPortForwardingSession \
        --parameters '{"portNumber":["22"], "localPortNumber":["56789"]}' \
        --target $TargetInstanceId
else
    aws ssm start-session --region us-west-1 --profile twp --target $TargetInstanceId
fi

