# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, modulesPath, ... }:

{
    imports =
        [ (modulesPath + "/installer/scan/not-detected.nix")
        ];

    boot = {
        kernelModules = [ "kvm-amd" "v4l2loopback" ];
        extraModulePackages = [config.boot.kernelPackages.v4l2loopback];
        initrd = {
            verbose = false;
            availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "rtsx_usb_sdmmc" ];
            kernelModules = [ "amdgpu" ];
        };
    };

    fileSystems = {
        "/" =
        { device = "/dev/disk/by-uuid/d5929593-79b4-428d-a2a9-a6497a96bf91";
            fsType = "btrfs";
            options = [ "subvol=@" "defaults" "noatime" "compress=zstd" "commit=120" ];
        };

        "/root" =
        { device = "/dev/disk/by-uuid/d5929593-79b4-428d-a2a9-a6497a96bf91";
            fsType = "btrfs";
            options = [ "subvol=@root" "defaults" "noatime" "compress=zstd" "commit=120"  ];
        };

        "/var/log" =
        { device = "/dev/disk/by-uuid/d5929593-79b4-428d-a2a9-a6497a96bf91";
            fsType = "btrfs";
            options = [ "subvol=@log" "defaults" "noatime" "compress=zstd" "commit=120"  ];
        };

        "/var/cache" =
        { device = "/dev/disk/by-uuid/d5929593-79b4-428d-a2a9-a6497a96bf91";
            fsType = "btrfs";
            options = [ "subvol=@cache" "defaults" "compress=lzo" "commit=120"  ];
        };

        "/tmp" =
        { device = "/dev/disk/by-uuid/d5929593-79b4-428d-a2a9-a6497a96bf91";
            fsType = "btrfs";
            options = [ "subvol=@tmp" "defaults" "nodiratime" "noatime" "compress=zstd" "commit=120"  ];
        };

        "/home" =
        { device = "/dev/sda2";
            fsType = "btrfs";
            options = [ "defaults" "nodiratime" "noatime" "compress=zstd" "commit=120"  ];
        };

        "/nix/store" =
        { device = "/dev/disk/by-uuid/eca28217-0a28-48e6-b00c-30d221da1c62";
            fsType = "btrfs";
            options = [ "defaults" "compress=lzo" "commit=120"  ];
        };

        "/boot" =
        { device = "/dev/disk/by-uuid/F50A-F67C";
            fsType = "vfat";
        };
    };

    swapDevices = [ ];

    # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
    # (the default) this is the recommended approach. When using systemd-networkd it's
    # still possible to use this option, but it's recommended to use it in conjunction
    # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
    networking.useDHCP = lib.mkDefault true;
    # networking.interfaces.wlp1s0.useDHCP = lib.mkDefault true;

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
