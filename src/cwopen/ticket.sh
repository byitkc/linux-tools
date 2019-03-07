#!/bin/bash

# This script will prompt for the user to enter a ticket number and will open it using the specified browser.

urlbase='https://portal.tgs-kc.com/v4_6_release/services/system_io/Service/fv_sr100_request.rails?service_recid='
browser='/usr/bin/google-chrome'

echo "Please input the ticket number you would like to open:"

ticket=$(zenity --entry --text "What ticket would you like to open?")

echo "Opening Ticket #$ticket"
ticketurl="$urlbase$ticket"

$browser $ticketurl