#!/bin/sh

ALIAS=$1
CREDFILE=$2

if [ ! -f "$CREDFILE" ]; then
  echo "$CREDFILE does not exist."
  
  echo "Creating Org"
  echo "------------"
  sfdx force:org:create --setalias "$ALIAS" --definitionfile ./config/project-scratch-def.json --durationdays 1
  sfdx force:org:display --targetusername "$ALIAS" --verbose > "$CREDFILE"
  echo ""
  cat "$CREDFILE"
else
  echo "$CREDFILE does exist. skip Creation"
  echo ""
  cat "$CREDFILE"
fi
