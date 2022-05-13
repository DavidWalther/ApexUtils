#!/bin/sh

ALIAS=$1
echo "Creating Org"
echo "------------"
sfdx force:org:create -a $ALIAS -f ./config/project-scratch-def.json -d 1