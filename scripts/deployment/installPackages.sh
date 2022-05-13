#!/bin/sh

ALIAS=$1
echo "Installing core pkg"
echo "-------------------"
sfdx force:package:install -u "$ALIAS" --package="core@0.1.0-1" --wait 60
retVal=$?
if [ $retVal -ne 0 ]; then
    exit $retVal
fi

echo "Installing mapping pkg"
echo "----------------------"
sfdx force:package:install -u "$ALIAS" --package="mapping@0.1.0-3" --wait 60
retVal=$?
if [ $retVal -ne 0 ]; then
  exit $retVal
fi