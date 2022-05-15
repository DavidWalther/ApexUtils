#!/bin/sh

ALIAS=$1
echo ""
echo "----------------------"
echo " push code"
echo "----------------------"
sfdx force:source:push --targetusername "$ALIAS" --forceoverwrite --wait 60
retVal=$?
if [ $retVal -ne 0 ]; then
  exit $retVal
fi

echo ""
echo "--------------------"
echo " run all tests"
echo "-------------------"
sfdx force:apex:test:run --targetusername "$ALIAS" --testlevel=RunLocalTests --resultformat=human --detailedcoverage --codecoverage --wait 60

#sfdx force:package:uninstall --targetusername "$ALIAS" --package="core@0.1.0-2" --wait 60
retVal=$?
if [ $retVal -ne 0 ]; then
    exit $retVal
fi