#!/bin/bash -e

if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    echo "You must source this script instead of running it. Try this instead : "
    echo ". $0 $*"
    echo ""
    exit 1
fi

IAM_ROLE_ARN="$1"
IAM_ROLE_SESSION_TIME=${2:-3600}
echo $IAM_ROLE_SESSION_TIME

[[ -z $IAM_ROLE_ARN ]] && (echo "please pass IAM_ROLE_ARN as first argument" && exit 113)


unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_SESSION_TOKEN

CREDS_JSON="$(aws sts assume-role --role-arn ${IAM_ROLE_ARN} --role-session-name DynamodbMigration --duration-seconds ${IAM_ROLE_SESSION_TIME})"

echo $CREDS_JSON

# Display on stdout
echo $CREDS_JSON | jq '.' 1>&2

export AWS_ACCESS_KEY_ID="$(echo $CREDS_JSON | jq -r '.Credentials.AccessKeyId')"
export AWS_SECRET_ACCESS_KEY="$(echo $CREDS_JSON | jq -r '.Credentials.SecretAccessKey')"
export AWS_SESSION_TOKEN="$(echo $CREDS_JSON | jq -r '.Credentials.SessionToken')"