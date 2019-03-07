#!/bin/bash

# This script will prompt for the user to enter a ticket number and will open it using the specified browser.

urlbase='https://portal.tgs-kc.com/v4_6_release/services/system_io/router/openrecord.rails?recordType=ProjectHeaderFV&recid='
browser='/usr/bin/google-chrome'

echo "Please input the project number you would like to open:"

id=$(zenity --entry --text "What project would you like to open?")

echo "Opening Project #$id"
idurl="$urlbase$id"

$browser $idurl