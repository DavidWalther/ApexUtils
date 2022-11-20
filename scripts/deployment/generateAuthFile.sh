#!/bin/sh

ALIAS=$1
sfdx force:org:display --targetusername "$ALIAS" --verbose --json
