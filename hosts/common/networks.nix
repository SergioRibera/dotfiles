{ config, lib, ... }:
{
  networking = {
    useDHCP = lib.mkForce false;
    networkmanager = {
      enable = true;
      dns = "none";
      insertNameservers = [
        "1.1.1.1"
        "8.8.8.8"
      ];
      unmanaged = [
        "lo"
        "docker0"
        "virbr0"
      ];
      wifi = {
        backend = "iwd";
        powersave = false;
      };
    };
    wireless.iwd = {
      enable = true;
      settings = {
        General.AddressRandomization = "once";
        General.AddressRandomizationRange = "full";
      };
    };
    # mdns
    firewall.allowedUDPPorts = [ 5353 ];
  };

  services.cloudflared = {
    enable = config.server-network;
    tunnels = {
      "0c3f67a9-326d-4318-8dcb-865ece218b2f" = {
        credentialsFile = config.age.secrets.cftun01.path;
        default = "http_status:404";
      };
    };
  };
  services.openssh.settings.Macs = [
    "hmac-sha2-512-etm@openssh.com"
    "hmac-sha2-256-etm@openssh.com"
    "umac-128-etm@openssh.com"
    "hmac-sha2-256"
  ];
  services.tailscale = {
    enable = config.games;
    extraDaemonFlags = [ "--no-logs-no-support" ];
  };
  networking.firewall.checkReversePath = lib.optionalString config.games "loose";
}
