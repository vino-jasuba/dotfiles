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


function select_instance {
    cache_file=$(get_cache_file)

    if [[ -s $cache_file ]]; then
        # Cache File Exists and is NOT empty
        selected_instance=$(cat $cache_file | fzf)
    else
        echo "Cache File Empty: Fetching EC2 instances"

        cache_aws_instances "$cache_file"

        selected_instance=$(cat $cache_file | fzf)
    fi

    echo $selected_instance
}

option=$1

case $option in
    "p" | "port-forward")
        # start port forwarding session on port 22
        TargetInstanceId=$(echo $(select_instance) | cut -d ':' -f 3 | xargs)

        aws ssm start-session --region us-west-1 --profile twp \
            --document-name AWS-StartPortForwardingSession \
            --parameters '{"portNumber":["22"], "localPortNumber":["56789"]}' \
            --target $TargetInstanceId
        ;;
    "r" | "refresh-cache")
        cache_aws_instances "$(get_cache_file)"
        ;;
    *)
        TargetInstanceId=$(echo $(select_instance) | cut -d ':' -f 3 | xargs)

        aws ssm start-session --region us-west-1 --profile twp --target $TargetInstanceId
esac


