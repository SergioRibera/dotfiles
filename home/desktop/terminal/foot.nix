{ pkgs, config, ... }: {
  home-manager.users.${config.user.username}.programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "CaskaydiaCove Nerd Font:size=10.0:fontfeatures=calt:fontfeatures=dlig:fontfeatures=liga;FiraCode Nerd Font:size=10.0:fontfeatures=calt:fontfeatures=dlig:fontfeatures=liga;Noto Color Emoji:size=10.0:fontfeatures=calt:fontfeatures=dlig";
        box-drawings-uses-font-glyphs = "yes";
        dpi-aware = "yes";
        horizontal-letter-offset = 0;
        vertical-letter-offset = 0;
        pad = "0x2center";
        selection-target = "clipboard";
        # include = "$XDG_CONFIG_HOME/foot/theme.ini";
      };
      scrollback = {
        lines = 10000;
        multiplier = 3;
      };
      desktop-notification.command = "${pkgs.libnotify}/bin/notify-send -a \${app-id} -i \${app-id} \${title} \${body}";
      url = {
        launch = "${pkgs.xdg-utils}/bin/xdg-open \${url}";
        label-letters = "sadfjklewcmpgh";
        osc8-underline = "url-mode";
        protocols = "http, https, ftp, ftps, file, mailto, ipfs";
        uri-characters = ''
          abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_.,~:;/?#@!$&%*+="'()[]'';
      };
      cursor = {
        style = "beam";
        beam-thickness = "2";
      };
      tweak = {
        font-monospace-warn = "no";
        sixel = "yes";
      };
      colors = {
        alpha = 1.0;
      };
    };
  };
}
