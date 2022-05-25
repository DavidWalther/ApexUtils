#!/bin/sh

ALIAS=$1
echo ""
echo "--------------------"
echo "Installing ApexUtilities-Core"
echo "-------------------"
sfdx force:package:install --targetusername "$ALIAS" --package="ApexUtilities-Core@1.1.0-1" --wait 60
retVal=$?
if [ $retVal -ne 0 ]; then
    exit $retVal
fi

echo ""
echo "----------------------"
echo "Installing ApexUtilities-Mapping"
echo "----------------------"
#sfdx force:package:install --targetusername "$ALIAS" --package="ApexUtilities-Mapping@1.1.0-1" --wait 60
sfdx force:package:install --targetusername "$ALIAS" --package="04t2o000000yUVtAAM" --wait 60

retVal=$?
if [ $retVal -ne 0 ]; then
  exit $retVal
fi