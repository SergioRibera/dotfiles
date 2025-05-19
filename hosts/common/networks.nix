{ config, ... }: {
  services.cloudflared = {
    enable = config.server-network;
    tunnels = {
      "0c3f67a9-326d-4318-8dcb-865ece218b2f" = {
        credentialsFile = config.age.secrets.cftun01.path;
        default = "http_status:404";
      };
    };
  };
}
