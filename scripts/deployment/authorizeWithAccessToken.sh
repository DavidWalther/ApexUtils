#!/bin/bash

# ==========================
# Parameters
# ==========================

FILEPATH=$1
ALIAS=$2


INSTANCE_URL_LINE=$( cat $FILEPATH | grep "Instance Url" )
INSTANCE_URL="${INSTANCE_URL_LINE/"Instance Url"/}"

ACCESS_TOKEN_LINE=$( cat $FILEPATH | grep "Access Token" )
ACCESS_TOKEN="${ACCESS_TOKEN_LINE/"Access Token"/}"

export SFDX_ACCESS_TOKEN=$ACCESS_TOKEN
printenv $SFDX_ACCESS_TOKEN


# ==========================
# Logic
# ==========================

sfdx auth:accesstoken:store --instanceurl="$INSTANCE_URL" --setalias="$ALIAS" --setdefaultusername --noprompt
