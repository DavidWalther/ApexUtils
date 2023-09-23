#!/bin/sh

ALIAS=$1
CREDFILE=$2

if [ ! -f "$CREDFILE" ]; then
  echo "$CREDFILE does not exist."
  
  echo "Creating Org"
  echo "------------"
  echo "create server.key-file for creation"
  echo "$SFDX_JWT_KEY" | base64 --decode > server.key
  echo "\nCreate Scratch Org"
  sfdx force:org:create --setalias "$ALIAS" --definitionfile ./config/project-scratch-def.json --durationdays 1
  echo "\nGet Scratch Org details"
  sfdx force:org:display --targetusername "$ALIAS" --verbose > "$CREDFILE"
  echo "\nScratch Org details"
  cat "$CREDFILE"
else
  echo "$CREDFILE does exist. skip Creation"
  echo ""
  cat "$CREDFILE"
fi
