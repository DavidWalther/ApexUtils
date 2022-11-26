#!/bin/bash

# ==========================
# Parameters
# ==========================

FILEPATH=$1
ALIAS=$2

echo $FILEPATH

INSTANCE_URL_LINE=$( cat $FILEPATH | grep "Instance Url" )
echo $INSTANCE_URL_LINE
INSTANCE_URL="${INSTANCE_URL_LINE/"Instance Url"/}"
echo $INSTANCE_URL

ACCESS_TOKEN_LINE=$( cat $FILEPATH | grep "Access Token" )
echo $ACCESS_TOKEN_LINE
ACCESS_TOKEN="${ACCESS_TOKEN_LINE/"Access Token"/}"
echo $ACCESS_TOKEN

export SFDX_ACCESS_TOKEN=$ACCESS_TOKEN
echo $SFDX_ACCESS_TOKEN


# ==========================
# Logic
# ==========================

sfdx auth:accesstoken:store --instanceurl="$INSTANCE_URL" --setalias="$ALIAS" --setdefaultusername --noprompt
