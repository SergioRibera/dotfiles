# NixOS Dotfiles — SergioRibera

Personal NixOS flake covering multiple machines and deployment variants from a single repo.

**Shell**: Nushell · **WM**: Niri (primary) · **Terminal**: Alacritty · **Editor**: Neovim + Neovide

---

## Variants

| Output | Format | Profile | Use case |
|---|---|---|---|
| `nixosConfigurations.laptop` | system | desktop | Personal laptop, AMD GPU, 1 monitor |
| `nixosConfigurations.race4k` | system | desktop | Desktop, Nvidia, 4 monitors, games + IA |
| `nixosConfigurations.rpi` | sd-image (aarch64) | server | Raspberry Pi headless appliance |
| `nixosConfigurations.wsl` | NixOS-WSL | wsl | Windows Subsystem for Linux |
| `packages.<system>.server-iso` | ISO | server | Headless appliance, boots ready |
| `packages.<system>.live-gui` | ISO | live-gui | Bootable live GUI, no install needed |
| `darwinConfigurations.mac` | nix-darwin | mac | macOS minimal (tools only) |

## Hosts

### `laptop`
- **GPU**: AMD (amdgpu, ROCm)
- **Screen**: eDP-1 · 1600×900
- **Browser**: Firefox
- **Extras**: touchpad, bluetooth

### `race4k`
- **GPU**: Nvidia (production driver, closed)
- **Screens**: DP-1 + DP-2 (rotated left) + DP-3 + HDMI-A-1 (rotated right) · 1080p
- **WM active**: niri
- **Browser**: Firefox
- **Extras**: CUDA container toolkit, ansync service, IA server, Steam + Gamemode

### `rpi`
- **Board**: Raspberry Pi (aarch64), extlinux bootloader
- **Mode**: headless, performance governor, no home-manager

### `wsl`
- **Mode**: headless, home-manager enabled, full nvim (no neovide)

---

## `nix run` Apps

```sh
nix run github:SergioRibera/dotfiles                        # show help + available options
nix run github:SergioRibera/dotfiles#install -- <host>      # install NixOS from live installer
nix run github:SergioRibera/dotfiles#install -- laptop      # → clones repo, generates hw config, nixos-install
nix run github:SergioRibera/dotfiles#install -- wsl         # → prints WSL import instructions
nix run github:SergioRibera/dotfiles#install -- rpi         # → prints sd-image dd command
nix run github:SergioRibera/dotfiles#rebuild                # nixos-rebuild / darwin-rebuild switch
nix run github:SergioRibera/dotfiles#update-pkgs            # upgrade custom package sources
nix run github:SergioRibera/dotfiles#nvim                   # full Neovim + Neovide
nix run github:SergioRibera/dotfiles#nvim-basic             # headless Neovim (no GUI)
nix run github:SergioRibera/dotfiles#fish                   # fish shell with dotfiles config
nix run github:SergioRibera/dotfiles#zellij                 # zellij with dotfiles config
```

> Tools in `tools/<name>/app.nix` are auto-discovered — no index to update.

---

## OCI Containers

```sh
nix build github:SergioRibera/dotfiles#nvim-container
docker load < result
```

> Tools in `tools/<name>/container.nix` are auto-discovered.

---

## Installation

### Fresh install

Boot into the NixOS installer, mount your disks at `/mnt`, then run the one-liner:

```sh
sudo -i
nix run github:SergioRibera/dotfiles#install -- <host>
```

The script clones the repo, generates `hardware-configuration.nix`, and runs `nixos-install` for you.
After reboot:

```sh
passwd                        # set password for s4rch
sudo chown -R $USER /etc/nixos
```

For other variants (`wsl`, `rpi`, ISOs) the script prints the specific instructions for each one.

### Update / switch (already installed)

```sh
nix run github:SergioRibera/dotfiles#rebuild
# or directly:
doas nixos-rebuild switch --flake /etc/nixos#<host>
```

### macOS (nix-darwin)

```sh
# first time
nix run nix-darwin -- switch --flake github:SergioRibera/dotfiles#mac

# subsequent updates
nix run github:SergioRibera/dotfiles#rebuild
```

## Thanks

- [Lemin-n](https://github.com/Lemin-n/dotfiles)
- [L I N U X](https://github.com/linuxmobile/kaku)
- [nmasur](https://github.com/nmasur/dotfiles)
- [badele](https://github.com/badele/nix-homelab)
