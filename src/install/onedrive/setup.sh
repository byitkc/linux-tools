#!/bin/bash

###
# Functions for . sourcing
###

pre_req_check() {
    if [ hash dmd ]; then
        continue
    else
        echo "It appears that the D Lang Compiler (dmd) is not installed or is not in your path. Please install it and ensure that dmd is included in your path before proceeding."
        exit 1
    fi
}


setup_onedrive() {

    # Checking for pre-reqs
    if [ pre_req_check ]; then
        continue
    else
        echo "There was a problem loading the required pre-reqs, please review the output above."
        exit 1
    fi

    # Setting Function Vars
    tempdir=$(mktemp -d)
    src_svc_dir="./src/install/services/user"
    systemd_user_services_dir="/usr/lib/systemd/user"
    prompt_delay = 10

    # Pulling latest Onedrive from Github
    echo "Temp Directory is $tempdir"
    mkdir $tempdir/onedrive
    git clone https://github.com/abraunegg/onedrive.git $tempdir/onedrive
    make -C $tempdir/onedrive
    sudo make install -C $tempdir/onedrive
    

    # Onedrive Personal Setup
    read -p "Would you like to setup a Personal Onedrive? [y/N]" -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        
        # Setting Vars
        od="onedrive-personal"

        # Configuring Log Directory
        _logdir="/var/log/onedrive-personal"
        if [ ! -d $_logdir ]; then
            sudo mkdir $_logdir
        fi
        sudo chown byoung:byoung $_logdir

        # Copying Configuration Information
        _odconfdir="~/.config/onedrive-personal"
        cp -r ./src/install/configurations/onedrive-personal ~/.config/.
        
        echo -e "\n\n###\nPlease review the configuration information below:\n###\n\n"
        onedrive --display-config --confdir=$_odconfdir
        read -p "Does the above configuraiton look correct? [y/N]" -n 1 -r
        echo -e "\n"
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            _delay=10
            echo -e "\n\n###\nSync starting in $_delay seconds.\n"
            echo -e "\nWe are going to start the sync now, once the sync starts successfully and you see files appeareing you can cancel the sync with ^C and exit the new terminal, otherwise this terminal will wait for the sync to complete to 100% which may take some time. It will sync once we enable the services later.\n###"
            sleep $_delay
            xfce4-terminal -e "onedrive --synchronize --verbose --confdir=$_odconfdir"
            read -p "Once you've setup the sync, press Enter here to continue" -n1 -s
            
            # Setup and Initialize Services
            sudo cp $src_svc_dir/$od.service $systemd_user_services_dir
            systemctl --user start $od.service
            systemctl --user enable $od.service

        else
            echo "Looks like something was wrong, please review and complete manually!"
        fi     
    fi

    echo -e "\n\n"

    # Onedrive Work Setup
    read -p "Would you like to setup a Work Onedrive? [y/N]" -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Setting Vars
        od="onedrive-work"

        # Configuring Log Directory
        _logdir="/var/log/onedrive-work"
        if [ ! -d $_logdir ]; then
            sudo mkdir $_logdir
        fi
        sudo chown byoung:byoung $_logdir

        # Copying Configuration Information
        _odconfdir="~/.config/onedrive-work"
        cp -r ./src/install/configurations/onedrive-work ~/.config/.
        
        echo -e "\n\n###\nPlease review the configuration information below:\n###\n\n"
        onedrive --display-config --confdir=$_odconfdir
        read -p "Does the above configuraiton look correct? [y/N]" -n 1 -r
        echo -e "\n"

        if [[ $REPLY =~ ^[Yy]$ ]]; then
            _delay=15
            echo -e "\n\n###\nSync starting in $_delay seconds.\n"
            echo -e "\nWe are going to start the sync now, once the sync starts successfully and you see files appeareing you can cancel the sync with ^C and exit the new terminal, otherwise this terminal will wait for the sync to complete to 100% which may take some time. It will sync once we enable the services later.\n###"
            sleep 15
            xfce4-terminal -e "onedrive --synchronize --verbose --confdir=$_odconfdir"
            read -p "Once you've setup the sync, press Enter here to continue" -n1 -s

        # Setup and Initialize Services
        sudo cp $src_svc_dir/$od.service $systemd_user_services_dir
        systemctl --user start $od.service
        systemctl --user enable $od.service

        else
            echo "Looks like something was wrong, please review and complete manually!"
        fi        
    fi
}