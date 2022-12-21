#!/bin/bash

FILEPATH=$1

USER_NAME_LINE=$( cat $FILEPATH | grep "Username" )
USER_NAME="${USER_NAME_LINE/"Username"/}"

echo $USER_NAME
