_: {
    boot = {
        consoleLogLevel = 0;
        initrd.verbose = false;
        plymouth.enable = true;
        kernelParams = [ "quiet" "splash" "rd.systemd.show_status=false" "rd.udev.log_level=3" "udev.log_priority=3" "boot.shell_on_fail" "acpi_backlight=native" ];
        supportedFilesystems = ["btrfs"];

        loader = {
            systemd-boot.enable = false;
            timeout = 0;

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
    };
}
