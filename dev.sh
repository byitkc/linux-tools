#!/bin/bash

echo "This is a place to test code that we're working on adding to other things."

###
# Sourcing other Files
###
source src/install/onedrive/setup.sh

###
# Setup
###

# Making a temporary directory to work from
tempdir=$(mktemp -d)

###
# Setting base vars
###

# Enable installation of KVM Virtualization Packages
virt="kvm"



function main() {
    read -p "Would you like to setup Onedrive CLI? [y/N]" -n 1 -r
    if  [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "\n"
        sudo -v
        setup_onedrive
    fi
}

###
# Main Execution
###

main

# Prompting for Sudo
# sudo -v

# read -p "Would you like to setup a Personal Onedrive? [y/N]" -n 1 -r
# if [[ $REPLY =~ ^[Yy]$ ]]; then
    
#     # Configuring Log Directory
#     _logdir="/var/log/onedrive-personal"
#     if [ ! -d $_logdir ]; then
#         sudo mkdir $_logdir
#     fi
#     sudo chown byoung:byoung $_logdir

#     # Copying Configuration Information
#     _odconfdir="~/.config/onedrive-personal"
#     cp -r ./src/install/configurations/onedrive-personal ~/.config/.
    
#     echo -e "\n\n###\nPlease review the configuration information below:\n###\n\n"
#     onedrive --display-config --confdir=$_odconfdir
#     read -p "Does the above configuraiton look correct? [y/N]" -n 1 -r
#     echo -e "\n"
#     if [[ $REPLY =~ ^[Yy]$ ]]; then
#         _delay=10
#         echo -e "\n\n###\nSync starting in $_delay seconds.\n"
#         echo -e "\nWe are going to start the sync now, once the sync starts successfully and you see files appeareing you can cancel the sync with ^C and exit the new terminal, otherwise this terminal will wait for the sync to complete to 100% which may take some time. It will sync once we enable the services later.\n###"
#         sleep $_delay
#         xfce4-terminal -e "onedrive --synchronize --verbose --confdir=$_odconfdir"
#         read -p "Once you've setup the sync, press Enter here to continue" -n1 -s

#     else
#         echo "Looks like something was wrong, please review and complete manually!"
#     fi     
# fi

# echo -e "\n\n"

# read -p "Would you like to setup a Work Onedrive? [y/N]" -n 1 -r
# if [[ $REPLY =~ ^[Yy]$ ]]; then
    
#     # Configuring Log Directory
#     _logdir="/var/log/onedrive-work"
#     if [ ! -d $_logdir]; then
#         sudo mkdir $_logdir
#     fi
#     sudo chown byoung:byoung $_logdir

#     # Copying Configuration Information
#     _odconfdir="~/.config/onedrive-work"
#     cp -r ./src/install/configurations/onedrive-work ~/.config/.
    
#     echo -e "\n\n###\nPlease review the configuration information below:\n###\n\n"
#     onedrive --display-config --confdir=$_odconfdir
#     read -p "Does the above configuraiton look correct? [y/N]" -n 1 -r
#     echo -e "\n"

#     if [[ $REPLY =~ ^[Yy]$ ]]; then
#         _delay=15
#         echo -e "\n\n###\nSync starting in $_delay seconds.\n"
#         echo -e "\nWe are going to start the sync now, once the sync starts successfully and you see files appeareing you can cancel the sync with ^C and exit the new terminal, otherwise this terminal will wait for the sync to complete to 100% which may take some time. It will sync once we enable the services later.\n###"
#         sleep 15
#         xfce4-terminal -e "onedrive --synchronize --verbose --confdir=$_odconfdir"
#         read -p "Once you've setup the sync, press Enter here to continue" -n1 -s
#     else
#         echo "Looks like something was wrong, please review and complete manually!"
#     fi        
# fi