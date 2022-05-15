#!/bin/sh

ALIAS=$1
echo ""
echo "----------------------"
echo "uninstall mapping pkg"
echo "----------------------"
sfdx force:package:uninstall --targetusername "$ALIAS" --package="mapping@0.1.0-4" --wait 60
retVal=$?
if [ $retVal -ne 0 ]; then
  exit $retVal
fi

echo ""
echo "--------------------"
echo "uninstall core pkg"
echo "-------------------"
sfdx force:package:uninstall --targetusername "$ALIAS" --package="core@0.1.0-4" --wait 60
retVal=$?
if [ $retVal -ne 0 ]; then
    exit $retVal
fi