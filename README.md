# Nodel Puppet Starter

A starter project for managing a digital interactive with nodel and puppet.

## Features:

- Installs required packages including puppet, java  and git using chocolatey.
- Downloads and installs nodel and adds the app launcher recipe (https://github.com/museumsvictoria/nodel-recipes/tree/master/App%20Launcher),
  - Manages updates to Nodel.
- Sets up a guest account that auto logs in and runs nodel.
- Delays windows automatic updates for the maximum period.
- Downloads a script for deploying application code from git or amazon s3 (https://github.com/rowead/deployer). It also installs aws-cli (https://aws.amazon.com/cli/).

## Details:

- Nodel is installed into C:\nodel
  - Nodel is run via the startup menu (C:/Users/kiosk/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup)
- All other scripts are installed in C:\kiosk  


## How to use:

Please use this for **testing purposes only**, you will almost definitely want to fork this and harden with your own passwords and use something like hiera-eyaml or other solutions to encrypt your secrets. You can also set up your own chocolatey source.

It will reboot the machine once nodel is installed but it will only install the nodel startup script after the kiosk user has logged in once (it needs to wait for the kiosk user's home folder etc. to be created by windows). You can just run the commands below again and it will eventually reboot once more to finish off the install.

### Users:

user: "kiosk", password: "pass", (managed through puppet)

user: "Vagrant", password: "vagrant", (unmanaged default set up for vagrant)

### Installing on a new Windows machine:

If you have a fresh install of Windows 10 you can install this with a single command. Run the following in a powershell window run as administrator.

```powershell
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/rowead/nodel-puppet-starter-windows/master/shell/install-puppet-git.ps1'))
```

This will also set up a scheduled task that pulls changes from this repo and run puppet regularly.



### In a Virtual Machine

1. Install Vagrant (https://www.vagrantup.com/) and Virtual box (https://www.virtualbox.org/).
1. Clone this repo and within the project folder run:

```
vagrant up
```

The scheduled task is not set up when installed via vagrant, to update, run:

```
vagrant provision
```
or:
```
vagrant reload --provision
```
