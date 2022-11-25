#!/bin/sh



KEY_FILE_PATH=$1
CLIENT_ID=$2
FILEPATH=$3
ALIAS=$4
SET_DEFAULTUSERNAME=$5



INSTANCE_URL_LINE=$( cat $FILEPATH | grep "Instance Url" )
INSTANCE_URL="${INSTANCE_URL_LINE/"Instance Url"/}"

USERNAME_LINE=$( cat $FILEPATH | grep "Username" )
USERNAME="${USERNAME_LINE/"Username"/}"

echo $INSTANCE_URL
echo $USERNAME




      # clientid: consumerKey,
      # username: scratchorg.username,
      # jwtkeyfile: serverKeyPath,
      # instanceurl: scratchorg.instanceUrl,
      # setalias: alias,
      # setdefaultusername:true