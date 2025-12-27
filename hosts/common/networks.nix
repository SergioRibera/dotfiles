{ config, ... }:
{
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
}
