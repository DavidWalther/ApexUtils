#!/bin/sh

ALIAS=$1
PKG_VERSION_CORE="ApexUtilities-Core@1.3.0-1"
PKG_VERSION_MAPPING="ApexUtilities-Mapping@4.0.0-1"

echo ""
echo "--------------------"
echo "Installing ApexUtilities-Core"
echo "-------------------"
sfdx force:package:install --targetusername "$ALIAS" --package="$PKG_VERSION_CORE" --wait 60
retVal=$?
if [ $retVal -ne 0 ]; then
    exit $retVal
fi

echo ""
echo "----------------------"
echo "Installing ApexUtilities-Mapping"
echo "----------------------"
sfdx force:package:install --targetusername "$ALIAS" --package="$PKG_VERSION_MAPPING" --wait 60

retVal=$?
if [ $retVal -ne 0 ]; then
  exit $retVal
fi