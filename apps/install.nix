{ pkgs, ... }:
let
  hosts = {
    laptop = "Personal laptop — AMD GPU, 1 monitor, touchpad";
    race4k = "Desktop — Nvidia GPU, 4 monitors, games + IA";
  };
  hostsText = pkgs.lib.concatStringsSep "\n" (
    pkgs.lib.mapAttrsToList (name: desc: "    ${name}     ${desc}") hosts
  );
  script = pkgs.writeShellApplication {
    name = "install";
    runtimeInputs = with pkgs; [ git nixos-install-tools coreutils util-linux ];
    text = ''
      NOC="\033[0m"
      BOLD="\033[1m"
      RED="\033[1;31m"
      GREEN="\033[1;32m"
      BLUE="\033[1;34m"
      CYAN="\033[1;36m"

      usage() {
        echo -e ""
        echo -e "  ''${BOLD}SergioRibera/dotfiles — installer''${NOC}"
        echo -e ""
        echo -e "  ''${CYAN}Usage:''${NOC}  nix run github:SergioRibera/dotfiles#install -- <host>"
        echo -e ""
        echo -e "  ''${CYAN}NixOS hosts (installed via nixos-install):''${NOC}"
        echo -e "    ''${BLUE}laptop''${NOC}     Personal laptop — AMD GPU, 1 monitor, touchpad"
        echo -e "    ''${BLUE}race4k''${NOC}     Desktop — Nvidia GPU, 4 monitors, games + IA"
        echo -e ""
        echo -e "  ''${CYAN}Other variants (images / external instructions):''${NOC}"
        echo -e "    ''${BLUE}wsl''${NOC}        NixOS-WSL — shows import instructions"
        echo -e "    ''${BLUE}rpi''${NOC}        Raspberry Pi — shows sd-image build command"
        echo -e "    ''${BLUE}server-iso''${NOC} Headless appliance ISO"
        echo -e "    ''${BLUE}live-gui''${NOC}   Bootable live GUI ISO"
        echo -e ""
        echo -e "  ''${CYAN}macOS (nix-darwin):''${NOC}"
        echo -e "    nix run nix-darwin -- switch --flake github:SergioRibera/dotfiles#mac"
        echo -e ""
      }

      HOST="''${1:-}"

      if [ -z "$HOST" ]; then
        usage
        exit 0
      fi

      case "$HOST" in
        wsl)
          echo -e ""
          echo -e "  ''${BOLD}NixOS-WSL install''${NOC}"
          echo -e ""
          echo -e "  Run from a Windows PowerShell (with Nix installed):"
          echo -e ""
          echo -e "    nix build github:SergioRibera/dotfiles#nixosConfigurations.wsl.config.system.build.tarball"
          echo -e "    wsl --import NixOS \$env:LOCALAPPDATA\\NixOS result\\tarball\\nixos-system-*.tar.gz"
          echo -e ""
          exit 0
          ;;
        rpi)
          echo -e ""
          echo -e "  ''${BOLD}Raspberry Pi SD image''${NOC}"
          echo -e ""
          echo -e "  Requires aarch64 builder or binfmt cross-compilation:"
          echo -e ""
          echo -e "    nix build github:SergioRibera/dotfiles#rpi"
          echo -e "    dd if=result/sd-image/*.img.zst of=/dev/mmcblkX bs=4M status=progress"
          echo -e ""
          exit 0
          ;;
        server-iso|live-gui)
          echo -e ""
          echo -e "  ''${BOLD}Build ISO: $HOST''${NOC}"
          echo -e ""
          echo -e "    nix build github:SergioRibera/dotfiles#$HOST"
          echo -e "    dd if=result/iso/*.iso of=/dev/sdX bs=4M status=progress"
          echo -e ""
          echo -e "  Test in QEMU:"
          echo -e "    qemu-system-x86_64 -cdrom result/iso/*.iso -m 4G -enable-kvm"
          echo -e ""
          exit 0
          ;;
        laptop|race4k)
          ;;
        *)
          echo -e "  ''${RED}Unknown host: $HOST''${NOC}"
          usage
          exit 1
          ;;
      esac

      TARGET="/mnt"

      # Sanity checks
      if ! mountpoint -q "$TARGET" 2>/dev/null; then
        echo -e "  ''${RED}Error:''${NOC} $TARGET is not mounted."
        echo -e "  Format and mount your disks at /mnt before running this installer."
        exit 1
      fi

      if [ "$(id -u)" != "0" ]; then
        echo -e "  ''${RED}Error:''${NOC} must run as root (sudo -i)."
        exit 1
      fi

      REPO="$TARGET/etc/nixos"

      echo -e ""
      echo -e "  ''${BOLD}Installing host: ''${BLUE}$HOST''${NOC}"
      echo -e ""

      # Clone repo if not already present
      if [ ! -d "$REPO/.git" ]; then
        echo -e "  ''${CYAN}Cloning dotfiles...''${NOC}"
        mkdir -p "$REPO"
        git clone --depth 1 https://github.com/SergioRibera/dotfiles "$REPO"
      else
        echo -e "  ''${CYAN}Repo already at $REPO, skipping clone.''${NOC}"
      fi

      # Generate hardware configuration
      echo -e "  ''${CYAN}Generating hardware-configuration.nix...''${NOC}"
      nixos-generate-config --root "$TARGET"
      rm -f "$TARGET/etc/nixos/configuration.nix"

      HW_GENERATED="$TARGET/etc/nixos/hardware-configuration.nix"
      HW_DEST="$REPO/hosts/$HOST/hardware-configuration.nix"

      if [ -f "$HW_GENERATED" ] && [ "$HW_GENERATED" != "$HW_DEST" ]; then
        mv "$HW_GENERATED" "$HW_DEST"
      fi

      # Install
      echo -e "  ''${CYAN}Running nixos-install...''${NOC}"
      nixos-install --flake "$REPO#$HOST" --no-root-passwd

      echo -e ""
      echo -e "  ''${GREEN}Done!''${NOC} Reboot, then:"
      echo -e ""
      echo -e "    passwd                       # set password for s4rch"
      echo -e "    sudo chown -R \$USER /etc/nixos"
      echo -e ""
    '';
  };
in
{
  type = "app";
  program = "${script}/bin/install";
}
