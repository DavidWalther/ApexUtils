#!/bin/sh

ALIAS=$1
sfdx force:org:delete --targetusername $ALIAS --noprompt