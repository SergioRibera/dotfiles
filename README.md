## Linux NixDots files
My personal dotfiles for a NixOS

> Wayland (Hyprland)

## Installation
To install it see the next steps:

> [!IMPORTANT]
> List of hosts:
> - laptop: settings for personal laptop with 2 monitors
>
> List of users:
> - s4rch: Personal user with graphical interface and ready-to-use environment

- Boot into the installer environment
- Format and mount your disks inside /mnt
- Run:
```sh
# go into a root shell
sudo su -

# go inside a shell with properly required programs
nix-shell -p git nixUnstable

# create this folder if necessary
mkdir -p /mnt/etc/

# clone the repo
git clone --depth 1 https://github.com/SergioRibera/Dotfiles /mnt/etc/nixos

# remove this file
# replace <host> by host you want install
rm /mnt/etc/nixos/hosts/<host>/hardware-configuration.nix

# generate the config and take some files
nixos-generate-config --root /mnt
rm /mnt/etc/nixos/configuration.nix
mv /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/hosts/<host>

# make sure you're in this path
cd /mnt/etc/nixos

# to install the xorg version:
# replace <host> by host you want install
nixos-install --flake '.#<host>'
```

- Reboot, login as root, and change the password for your user using `passwd`
- Log-in in the displayManager.
- Then do this:
```sh
sudo chown -R $USER /etc/nixos
```

## Thanks to
This good people who helped me when learning nix-related stuff! really, thanks!

- [Lemin-n](https://github.com/Lemin-n/dotfiles)
- [L I N U X](https://github.com/linuxmobile/kaku)
