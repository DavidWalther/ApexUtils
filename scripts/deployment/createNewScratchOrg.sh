#!/bin/sh

ALIAS=$1
CREDFILE=$2

if [ ! -f "$CREDFILE" ]; then
  echo "$CREDFILE does not exist."
  
  echo "Creating Org"
  echo "------------"
  sfdx force:org:create --setalias "$ALIAS" --clientid="$SFDX_CONSUMER_KEY" --definitionfile ./config/project-scratch-def.json --wait=20 --durationdays 1
  sfdx force:org:display --targetusername "$ALIAS" --verbose > "$CREDFILE"
  echo ""
else
  echo "$CREDFILE does exist. skip Creation"
  echo ""
fi
