#!/bin/sh

ALIAS=$1
AUTHFILE=$2

if [ ! -f "$AUTHFILE" ]; then
  echo "$AUTHFILE does not exist."
  
  echo "Creating Org"
  echo "------------"
  sfdx force:org:create --setalias $ALIAS --definitionfile ./config/project-scratch-def.json --durationdays 1
fi
