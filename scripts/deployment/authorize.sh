#!/bin/sh



JWT=$1
CLIENT_ID=$2

# Path to the NON-JSON-file containin org details
FILEPATH=$3

# Alias for the authorized org
ALIAS=$4

# optional parameter
SET_DEFAULTUSERNAME=$5

#extract instance url from org details
INSTANCE_URL_LINE=$( cat $FILEPATH | grep "Instance Url" )
INSTANCE_URL="${INSTANCE_URL_LINE/"Instance Url"/}"

#extract username from org details
USERNAME_LINE=$( cat $FILEPATH | grep "Username" )
USERNAME="${USERNAME_LINE/"Username"/}"


