#!/bin/bash


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


# Make sure we don't run this as root!
if [ "$EUID" -eq 0 ]
  then echo "This is not designed to be ran as root, please re-run as your user!"
  exit
fi

# Determining if there is a GUI running
if [ $DESKTOP_SESSION ]; then
    gui=True
else
    gui=False
fi


if [ ! -d ~/VMs ]
    then
        echo "Creating VM's Folder"
        mkdir ~/VMs
fi

# Initialize Array for Package Management Removal
PACMAN_REMOVE=()

# Initialize Array for Package Management Installation
PACMAN_INSTALL=()

# Adding GUI and non-GUI specific items
if [ $gui ]; then

    # Adding Basic GUI Utilities
    PACMAN_INSTALL+=( \
        icedtea-web \
    )

    # Adding Ardunio Support
    PACMAN_INSTALL+=( \
        arduino \
    )

    # Adding Preferred Web Browser
    PACMAN_INSTALL+=( \
        firefox \
    )

    # Adding Remmina and Plugins
    PACMAN_INSTALL+=( \
        freerdp \
        libvncserver \
        remmina \
        spice-gtk \
        telepathy-glib \
        xorg-server-xephyr \
    )
    
    # Define packages that should be installed by PAMAC from AUR
    PAMAC_BUILD=( \
        nomachine \
        visual-studio-code-bin \
        wavebox-bin \
    )

else
    echo "Nope!"
    #PACMAN_INSTALL+=()
fi



# Basic Tools
PACMAN_INSTALL+=( \
    bash-completion \
    bind-tools \
    fakeroot \
    git \
    libnotify \
    make \
    openvpn \
    python-pip \
    python3 \
    vim \
    xorg-xprop \
    )

# SSH Server
PACMAN_INSTALL+=( \
    openssh \
)



# Adding Dependencies for OneDrive
PACMAN_INSTALL+=( \
    curl \
    dmd \
    sqlite \
)



# Adding Virtualization Support via QEMU/KVM
if [ "$virt" = "kvm" ]; then
    PACMAN_INSTALL+=( \
        bridge-utils \
        dnsmasq \
        ebtables \
        openbsd-netcat \
        qemu \
        vde2 \
        virt-manager \
    )
fi

# Define packages that should be installed by PAMAC from AUR
PAMAC_BUILD=( \
    nomachine \
    visual-studio-code-bin \
    wavebox-bin \
)

# Installation of Groups
GROUPINSTALL=()

# OBS Install

# Ensure that we are starting updated to the latest packages
sudo pacman -Syyu

# Removing packages that we don't want
sudo pacman -R ${PACMAN_REMOVE[*]}

# Performing installation of all repo-based applications
sudo pacman -S --needed ${PACMAN_INSTALL[*]} --noconfirm

###
# Additional Installations outside of Package Management
###

# Starting Virtualization
echo "Enabling Libvirtd and starting Default Adapter"
sudo systemctl enable libvirtd
sudo systemctl start libvirtd
sudo virsh net-start default
sudo virsh net-enable default

# Need to build D Lang Prep for Onedrive

# Installing some Linters for Python (To avoid BS in VS Code in the future)
pip3 install --user setuptools
pip3 install --user wheel
pip3 install --user pylint
pip3 install --user rope

### Adding some Aliases
#ALIASES=(
#    ll='ls -lh' \
#    vi='vim' \
#)
#
#for i in "${ALIASES[@]}"
#do
#    echo "alias $i" >> ~/.bashrc
#done
#source ~/.bashrc

###
# Application Configuraiton
###


### Visual Studio Code
if [ hash code ]; then
    # Adding some extensions to Visual Studio Code
    code --install-extension Shan.code-settings-sync
else
    echo "There was a problem locating Visual Studio Code, skipping autoconfig"
fi

### OneDrive Sync
read -p "Would you like to setup Onedrive CLI? [y/N]" -n 1 -r
if  [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "\n"
    sudo -v
    setup_onedrive
fi

### ASDM Launcher
sudo cp -r ./src/install/launchers/asdm /opt/asdm
sudo chmod -R +x /opt/asdm
sudo ln -s /opt/asdm/asdm.sh /usr/bin/asdm

# Going to want to loop here
# systemctl --user enable #service
# systemctl --user start #service
echo "You're going to have to manually start and enable the services that were setup here. See issue #6"
read -p "Once you have completed the instructions in #6, please press Enter!" -n1 -s

# Setup Remmina Directory
if [ ! -L ~/.local/share/remmina ]
    then
        echo "We are mapping Remmina settings to a shared file at ~/OneDrive-Personal/Settings/remmina"
        if [ -d ~/.local/share/remmina ]
            then
                echo "Moving existing remmina folder to remmina.old"
                mv ~/.local/share/remmina ~/.local/share/remmina.old
            else
                echo "Existing remmina folder not found, skipping move."
        fi
        echo "Creating Symlink for Remmina Settings"
        ln -s ~/onedrive-personal/Settings/remmina ~/.local/share/remmina
    else
        echo "Link already established for save Remmina Sessions"
fi

# We are going to link to the Shared Font directory.
if [ ! -L ~/.local/share/fonts ]
    then
        echo "We are mapping the user fons to a shared file at ~/OneDrive-Personal/Settings/fonts"
        if [ -d ~/.local/share/fonts ]
            then
                echo "Moving existing Fonts folder to backup folder (~/fonts.old)"
                mv ~/.local/share/fonts ~/.local/share/fonts.old
        fi
        echo "Establishing link for Shared Fonts!"
        ln -s ~/onedrive-personal/Settings/fonts ~/.local/share/fonts
    else
        echo "Link alread established for Fonts, skipping."
fi

# We are going to link to the Shared VPN Profile directory.
if [ ! -L ~/vpns ]
    then
        echo "We are mapping the user VPNs to a shared file at ~/OneDrive-Personal/Settings/VPNs"
        if [ -d ~/vpns ]
            then
                echo "Moving existing VPNs folder to backup folder (~/VPNs.old)"
                mv ~/vpns ~/vpns.old
        fi
        echo "Establishing link for VPNs!"
        ln -s ~/onedrive-personal/Settings/VPNs ~/vpns
    else
        echo "Link alread established for VPNs, skipping."
fi
