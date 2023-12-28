#!env /bin/bash

# Reset
Color_Off='\033[0m'       # Text Reset

# Bold
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BWhite='\033[1;37m'       # White

# Underline
UWhite='\033[4;37m'       # White

database="woundpros_development"
password="password"
query="select email from users where email like '%example%'"

aws_profile="twp"
aws_region="us-west-1"

development_emails=$(mysql -u root -h 127.0.0.1 -p$password -e "$query" $database | grep -e '[a-zA-Z0-9._]\+@[a-zA-Z]\+.[a-zA-Z]\+')

for email in $development_emails
do
	echo "${BYellow}Attempting to add ${UWhite}$email${Color_Off} ${BYellow}to suppression list"

	aws sesv2 put-suppressed-destination --email-address $email --reason BOUNCE --profile $aws_profile --region $aws_region

	echo "${BGreen}Added ${UWhite}$email${Color_Off} ${BGreen}to suppression list. They will no longer receive any emails\n"
done