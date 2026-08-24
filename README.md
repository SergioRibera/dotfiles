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

### Profiles

| Profile | GUI | HM | WM | Boot |
|---|---|---|---|---|
| `base` | — | — | — | UEFI / extlinux |
| `desktop` | ✓ | ✓ | niri · hyprland · sway · jay · mango | systemd-boot |
| `server` | — | — | — | systemd-boot |
| `live-gui` | ✓ | ✓ | niri | systemd-boot · autologin |
| `wsl` | — | ✓ | — | WSL2 (no bootloader) |
| `mac` | — | ✓ | — | macOS |

---

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
nix run github:SergioRibera/dotfiles              # show help
nix run github:SergioRibera/dotfiles#rebuild      # nixos-rebuild / darwin-rebuild switch
nix run github:SergioRibera/dotfiles#update-pkgs  # upgrade custom package sources
nix run github:SergioRibera/dotfiles#nvim         # full Neovim + Neovide
nix run github:SergioRibera/dotfiles#nvim-basic   # headless Neovim (no GUI)
nix run github:SergioRibera/dotfiles#fish         # fish shell with dotfiles config
nix run github:SergioRibera/dotfiles#zellij       # zellij with dotfiles config
```

> Tools in `tools/<name>/app.nix` are auto-discovered — no index to update.

---

## OCI Containers

```sh
nix build github:SergioRibera/dotfiles#nvim-container
docker load < result

nix build github:SergioRibera/dotfiles#simple-commits-container
nix build github:SergioRibera/dotfiles#wakatime-ls-container
nix build github:SergioRibera/dotfiles#discord-presence-container
```

> Tools in `tools/<name>/container.nix` are also auto-discovered.

---

## Installation

### NixOS (laptop / race4k)

Boot into the NixOS installer, mount your disks at `/mnt`, then:

```sh
sudo -i
nix-shell -p git
mkdir -p /mnt/etc/nixos

git clone --depth 1 https://github.com/SergioRibera/dotfiles /mnt/etc/nixos
cd /mnt/etc/nixos

# generate hardware config
nixos-generate-config --root /mnt
rm /mnt/etc/nixos/configuration.nix
mv /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/hosts/<host>/

# replace <host> with: laptop or race4k
nixos-install --flake '.#<host>'
```

After reboot, set your password and take ownership:

```sh
passwd
sudo chown -R $USER /etc/nixos
```

### Live GUI ISO

```sh
nix build github:SergioRibera/dotfiles#live-gui
dd if=result/iso/*.iso of=/dev/sdX bs=4M status=progress
# or test in QEMU:
qemu-system-x86_64 -cdrom result/iso/*.iso -m 4G -enable-kvm
```

### Server / Appliance ISO

```sh
nix build github:SergioRibera/dotfiles#server-iso
dd if=result/iso/*.iso of=/dev/sdX bs=4M status=progress
```

### Raspberry Pi SD image

```sh
# requires aarch64 builder or binfmt cross-compilation
nix build github:SergioRibera/dotfiles#rpi
dd if=result/sd-image/*.img.zst of=/dev/mmcblkX bs=4M status=progress
```

### NixOS-WSL

```sh
nix build github:SergioRibera/dotfiles#nixosConfigurations.wsl.config.system.build.tarball
wsl --import NixOS %LOCALAPPDATA%\NixOS result/tarball/nixos-system-*.tar.gz
```

### macOS (nix-darwin)

```sh
nix run nix-darwin -- switch --flake github:SergioRibera/dotfiles#mac
```

---

## Repo structure

```
flake.nix            # inputs + flake-parts.lib.mkFlake
flake-modules/       # overlays · packages · containers · apps · hosts · isos · darwin
profiles/            # composition layer: base · desktop · server · live-gui · wsl · mac
hosts/               # per-machine hardware deltas
  common/            # shared NixOS options and modules
  laptop/  race4k/  rpi/  wsl/  mac/  server-iso/  live-gui/
tools/               # SSOT building blocks (module.nix · hm.nix · app.nix · container.nix)
  nvim/  fish/  zellij/
home/                # NixOS+HM wiring: delegates to tools/*/hm.nix
  wm/  desktop/  shells/  tools/  editors/  common/
apps/                # nix run entrypoints: help · rebuild · update-pkgs
pkgs/                # custom packages overlay
lib/                 # mk-host.nix · mk-darwin.nix
colorscheme/         # gruvbox-dark and others
```

---

## Thanks

- [Lemin-n](https://github.com/Lemin-n/dotfiles)
- [L I N U X](https://github.com/linuxmobile/kaku)
- [nmasur](https://github.com/nmasur/dotfiles)
- [badele](https://github.com/badele/nix-homelab)
