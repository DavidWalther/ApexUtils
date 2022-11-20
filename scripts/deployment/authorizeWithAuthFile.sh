#!/bin/sh

ALIAS=$1
FILEPATH=$2
SETDEFAULTUSERNAME=$3

sfdx auth:sfdxurl:store --setalias "$ALIAS" --sfdxurlfile "$FILEPATH" "$SETDEFAULTUSERNAME"