{
  description = "SergioRibera NixOS System Configuration";
  outputs = inputs:
    inputs.flake-parts.lib.mkFlake
      {
        inherit inputs;
      }
      {
        systems = [ "x86_64-linux" ];

        perSystem =
          { config
          , pkgs
          , ...
          }: {
            devShells.default = pkgs.mkShell {
              packages = [ pkgs.alejandra pkgs.git ];
              name = "Zenparadise";
              DIRENV_LOG_FORMAT = "";
            };

            flake.nixosConfigurations =
              withSystem "x86_64-linux"
                { system
                , config
                , self'
                , ...
                }:
                let
                  systemInputs = { _module.args = { inherit inputs; }; };
                  inherit (inputs.nixpkgs.lib) nixosSystem;
                  allowUnfree = { nixpkgs.config.allowUnfree = true; };
                in
                {
                  s4rch = nixosSystem {
                    users.users.s4rch = {
                      isNormalUser = true;
                      username = "Sergio Ribera";
                      extraGroups = [ "wheel" "docker" "networkmanager" ];
                    };
                    nixpkgs.config.allowUnfree = true;
                    nix.settings.experimental-features = [ "nix-command" "flakes" ];
                    environment.systemPackages = [
                      microsoft-edge
                      discord
                      git
                      curl
                      wget
                      ouch
                      bluez
                      ripgrep
                      # Xserver
                      xdg-utils
                      pavucontrol

                      # Docker
                      docker-compose

                      # Font
                      font-manager

                      #Hyprland
                      wev
                    ];
                    programs.neovim.enable = true;
                    programs.neovim.defaultEditor = true;

                    programs.flameshot.enable = true;
                    programs.fish.enable = true;
                    programs.wezterm.enable = true;

                    programs.hyprland.enable = true;

                    networking.networkmanager.enable = true;

                    boot.loader = {
                      systemd-boot.enable = false;
                      efi = {
                        canTouchEfiVariables = true;
                        efiSysMountPoint = "/boot";
                      };
                      grub = {
                        enable = true;
                        device = "nodev";
                        efiSupport = true;
                        useOSProber = true;
                      };
                    };
                    openssh = {
                      enable = true;
                      settings = {
                        PasswordAuthentication = true;
                        PermitRootLogin = "no";
                      };
                    };
                    sound.enable = true;
                    gnome.gnome-keyring.enable = true;
                    pipewire = {
                      enable = true;
                      alsa.enable = true;
                      alsa.support32Bit = true;
                      jack.enable = true;
                      pulse.enable = true;
                    };
                    virtualisation = {
                      docker = {
                        enable = true;
                        enableOnBoot = true;
                      };
                    };
                    xdg.portal = {
                      enable = true;
                      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
                    };
                  };
                  specialArgs = {
                    inherit inputs;
                  };
                };
            # Nix Formatter
            formatter = pkgs.alejandra;
          };
      };

  inputs = {
    fenix = {
      url = "github:nix-community/fenix";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    hm = {
      url = "github:nix-community/home-manager";
    };
  };
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://helix.cachix.org"
      "https://fufexan.cachix.org"
      "https://nix-gaming.cachix.org"
      "https://hyprland.cachix.org"
      "https://cache.privatevoid.net"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "fufexan.cachix.org-1:LwCDjCJNJQf5XD2BV+yamQIMZfcKWR9ISIFy5curUsY="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "cache.privatevoid.net:SErQ8bvNWANeAvtsOESUwVYr2VJynfuc9JRwlzTTkVg="
    ];
  };
}
