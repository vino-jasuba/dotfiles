#!/bin/bash

EC_API_KEY="<api-key>"

cat delete-targets.txt | while read index_name
do
	echo "Deleting $index_name"

	curl -XDELETE "https://thewoundprosc.es.us-west-1.aws.found.io:9243/$index_name" -H "Authorization: ApiKey $EC_API_KEY" | jq
done
