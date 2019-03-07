# OneDrive CLI Client Additional Instructions

Here we are going to cover some additional instructions that must be followed after the OneDrive CLI Client from https://github.com/abraunegg/onedrive is installed.

## Create Configuration Directory

For each onedrive that we are going to sync we need to create a configuration folder in ~/.config or another location. In that folder we should copy the "config" template from the onedrive application directory. (If you install using the script this should be ~/Applications/onedrive).

Edit the `config` file here to include the directory you would like to use to sync this specific onedrive.

Next we need to create a custom systemd `.service` account. In the onedrive application directory, just make a copy of the `onedrive.service` file and name it something like, `onedrive-work.service` or something similar.

Edit the new file and modify the exec line to include the `--confdir` option which points the system to your new configuration directory.

Ex. if I created the config dir as `~/.config/onedrive-work` then I would append `--confdir="~/.config/onedrive-work` to the end of the exec line as a portion of the command.

Now, you need to run the following command once.

```onedrive --synchronize --verbose --confdir="~/.config/onedrive-work```

It will prompt you to copy and paste a link in order to complete authentication. Go ahead and copy that into a web browser and completed sign in. A blank page should load and you should see a new URL in your address bar. Copy and paste that back into the program.

### NOTE: I've seen issues where it will download a file instead of returning the URL. Seen in Google Chrome 72.0 in Xubuntu 18.10. If your browser attempts to download a file please try another browser. Using Firefox worked for me

Once the system starts to sync you can kill the process using CTRL+C.

Copy the new service you created into `/usr/lib/systemd/user/` and run:

```bash
systemctl --user enable onedrive-work.service
systemctl --user start onedrive-work.service
```

Once you've started and enabled the new service at runtime, review it by running

```bash
systemctl --user status onedrive-work.service
```

You should see files syncing now or at least the program reporting that it's waiting a while before syncing.