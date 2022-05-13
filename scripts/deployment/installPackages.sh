#!/bin/sh

ALIAS=$1
echo ""
echo "--------------------"
echo "Installing core pkg"
echo "-------------------"
sfdx force:package:install --targetusername "$ALIAS" --package="core@0.1.0-2" --wait 60
retVal=$?
if [ $retVal -ne 0 ]; then
    exit $retVal
fi

echo ""
echo "----------------------"
echo "Installing mapping pkg"
echo "----------------------"
sfdx force:package:install --targetusername "$ALIAS" --package="mapping@0.1.0-3" --wait 60
retVal=$?
if [ $retVal -ne 0 ]; then
  exit $retVal
fi