#!/bin/sh

ALIAS=$1
echo "Installing core pkg"
echo "-------------------"
sfdx force:package:install -u "$ALIAS" --package="core@0.1.0-1" --wait 30
retVal=$?
if [ $retVal -ne 0 ]; then
    echo "Error"
fi
exit $retVal

echo "Installing mapping pkg"
echo "----------------------"
sfdx force:package:install -u "$ALIAS" --package="mapping@0.1.0-3" --wait 30
retVal=$?
if [ $retVal -ne 0 ]; then
    echo "Error"
fi
exit $retVal