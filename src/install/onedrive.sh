#!/bin/bash

# Checking for and creating Application directory
if [ -d ~/Applications ]
    then
        echo "Applications Directory Exists"
    else
        mkdir ~/Applications
fi

git clone https://github.com/abraunegg/onedrive.git ~/Applications/onedrive

if [ ! -d ~/Applications/onedrive ]; then
    echo "There was a problem cloning the onedrive application to the directory. Please validate installation instructions and script by reviewing the setup at https://github.com/abraunegg/onedrive"
    exit 1
fi


if [ -d ~/dlang ]; then
    source ~/dlang/dmd*/activate
else
    echo "You must install DLang before beginning. https://dlang.org/"
    exit 1
fi

~/Applications/onedrive/make
sudo ~/Applications/onedrive/make install

echo "You're going to want to following some additional instructions in the 'onedrive.md' file in the docs directory!"
