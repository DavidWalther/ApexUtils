#!/bin/sh

ALIAS=$1
echo "Creating Org"
echo "------------"
sfdx force:org:create --setalias $ALIAS --definitionfile ./config/project-scratch-def.json --durationdays 1