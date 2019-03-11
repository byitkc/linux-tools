# Startup script to prompt for some basic setup. Not really automated atm, but will automate as time goes on.
# Idea of this is to start as a portion of xinit.

### Network Enable
read -p "Would you like to setup Onedrive CLI? [y/N]" -n 1 -r
if  [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "\n"
    sudo -v
    setup_onedrive
fi