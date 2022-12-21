#!/bin/bash

# ==========================
# Parameters
# ==========================

FILEPATH=$1
ALIAS=$2


INSTANCE_URL_LINE=$( cat $FILEPATH | grep "Instance Url" )
INSTANCE_URL="${INSTANCE_URL_LINE/"Instance Url"/}"

echo "echo"
echo $INSTANCE_URL
echo $SFDX_ACCESS_TOKEN
echo $ALIAS
echo ""
#echo "printenv"
#printenv $SFDX_ACCESS_TOKEN

# ==========================
# Logic
# ==========================

sfdx auth:accesstoken:store --instanceurl="$INSTANCE_URL" --setalias="$ALIAS" --setdefaultusername --noprompt
