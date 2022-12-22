#!/bin/bash

FILEPATH=$1

EXTRACT_LINE=$( cat $FILEPATH | grep "Instance Url" )
EXTRACT="${EXTRACT_LINE/"Instance Url"/}"

echo $EXTRACT
