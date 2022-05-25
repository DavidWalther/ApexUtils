#!/bin/sh

ALIAS=$1
echo ""
echo "----------------------"
echo "uninstall ApexUtilities-Mapping"
echo "----------------------"
sfdx force:package:uninstall --targetusername "$ALIAS" --package="ApexUtilities-Mapping@1.1.0-1" --wait 60
retVal=$?
if [ $retVal -ne 0 ]; then
  exit $retVal
fi

echo ""
echo "--------------------"
echo "uninstall ApexUtilities-Core"
echo "-------------------"
sfdx force:package:uninstall --targetusername "$ALIAS" --package="ApexUtilities-Core@1.1.0-1" --wait 60
retVal=$?
if [ $retVal -ne 0 ]; then
    exit $retVal
fi