#!/bin/bash

# Setting Static Type for now
type="Ticket"

### Initialization Checks!

    # Make sure we don't run this as root!
    if [ "$EUID" -eq 0 ]
        then 
            echo "This is not designed to be ran as root, please re-run as your user!"
            exit
    fi


    # This script will prompt for the user to enter a ticket number and will open it using the specified browser.

    
    browser='/usr/bin/google-chrome'

    echo "Please input the item number you would like to open:"

    item=$(zenity --entry --text "What item would you like to open?" --title "Open Manage Item")
    
    length=`awk -F '[0-9]' '{print NF-1}' <<< $item`

    re='^[0-9]+$'
            if ! [[ $item =~ $re ]] ; then
                echo "error: Not a number" >&2; exit 1
            fi
    if [ $length -lt "5" ]
        then
            urlbase='https://portal.tgs-kc.com/v4_6_release/services/system_io/router/openrecord.rails?recordType=ProjectHeaderFV&recid='
        else
            urlbase='https://portal.tgs-kc.com/v4_6_release/services/system_io/Service/fv_sr100_request.rails?service_recid='
    fi

    echo "Opening Item #$item"
    itemurl="$urlbase$item"

    $browser $itemurl
