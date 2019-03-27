#!/bin/bash

# Setting our working directory to the install script location since we
# are aware of the directory structure here
cd "$(dirname "$0")"

sudo cp ./rclone-sync.sh /usr/local/bin/.

sudo cp ../../services/user/rclone-*.service /usr/lib/systemd/user/.

# Creating directories if they do not exist
# we should move this into an array that is populated by a configuraiton file?
if [ ! -d /home/byoung/onedrive-personal ]; then
    mkdir /home/byoung/onedrive-personal
fi

if [ ! -d /home/byoung/onedrive-work ]; then
    mkdir /home/byoung/onedrive-work
fi

if [ ! -d /home/byoung/gdrive ]; then
    mkdir /home/byoung/gdrive
fi

# Create the remote objects
echo "We are going to have to create the applicable remote setups manually by running"
echo "rclone config for each directory to sync. By default we are syncing:"
echo "onedrive-personal"
echo "onedrive-work"
echo "gdrive"
read -p "Once you have completed this, please press Enter!" -n1 -s

echo "You must now start the services that are required by running: "
echo "systemctl --user start <service>"
echo "for all rclone-* services"

