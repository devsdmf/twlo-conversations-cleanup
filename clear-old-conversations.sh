#!/bin/sh

# TWILIO CONVERSATION CLEAN-UP SCRIPT
#
# Author: Lucas Mendes (lmendes@twilio.com)
#
# This script requires the following binaries:
# - Twilio CLI with a profile setup
# - jq for json parsing and filtering
# - grep for validations

if ! command -v twilio &> /dev/null
then
    echo "Error: Twilio CLI is not installed or could not be found, please check your include path"
    exit 1;
fi

if ! command -v jq &> /dev/null
then
    echo "Error: JQ is not installed or could not be found, please check your include path"
    exit 1;
fi

if ! command -v grep &> /dev/null
then
    echo "Error: Grep is not installed or could not be found, please check your include path"
    exit 1;
fi

show_help()
{
    echo
    echo "Twilio :: Conversations Clean-Up Script"
    echo
    echo "Syntax: ./clear-old-conversations.sh {chat-service-sid} {from-date}"
    echo
    echo "arguments:"
    echo "\t{chat-service-sid}\tthe chat service ID to query conversations, i.e. ISXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
    echo "\t{from-date}\t\tthe offset date to filter conversations, in the following format: yyyy-mm-ddThh:ii:ss"
    echo
    echo "options:"
    echo "\t-h\tshows this help message"
    echo
}

if [ $# -eq 0 ]; then
    echo "Error: no arguments supplied"
    show_help
    exit 1;
fi

while getopts ":h" option; do
    case $option in
        h)
            show_help
            exit;;
    esac
done

if [ -z "$1" ] || [ $(echo "$1" | grep -E -q -v '^IS[0-9a-fA-F]{32}$') ]; then
    echo "Error: Invalid chat-service-sid"
    show_help
    exit 1;
fi

if [ -z "$2" ] || [ $(echo "$2" | grep -E -q -v '^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}$') ]; then
    echo "Error: Invalid from-date"
    show_help
    exit 1;
fi

CHAT_SERVICE_ID="${1}"
FROM_DATE="${2}"

echo "Fetching conversations using Twilio CLI for chat service ${CHAT_SERVICE_ID} older than ${FROM_DATE}... \c"
CONVERSATIONS=$(twilio api:conversations:v1:services:conversations:list --chat-service-sid=$CHAT_SERVICE_ID -o json \
    | jq --raw-output --arg f $FROM_DATE 'map({ sid, dateCreated, dateUpdated, friendlyName, attributes: .attributes | fromjson }) |
    map(select(((.dateUpdated[:19] | .+"Z") | . < $f) and (.attributes.status == "INACTIVE") and (.attributes.long_lived == true))) |
    map(.sid) | join(" ")')
CONVERSATIONS_ARR=( $CONVERSATIONS )
echo "done!"

echo 

for c in "${CONVERSATIONS_ARR[@]}"; do
    echo "Removing conversation ${c}... \c"
    twilio api:conversations:v1:services:conversations:remove --chat-service-sid=$CHAT_SERVICE_ID --sid $c
    if [ $? -eq 0 ]; then
        echo "success!"
    else
        echo "error!"
    fi
done
