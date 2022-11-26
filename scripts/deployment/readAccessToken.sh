#!/bin/bash

FILEPATH=$1

ACCESS_TOKEN_LINE=$( cat $FILEPATH | grep "Access Token" )
ACCESS_TOKEN="${ACCESS_TOKEN_LINE/"Access Token"/}"

echo $ACCESS_TOKEN
