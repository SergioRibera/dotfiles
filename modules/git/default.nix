{ config }:
let
  inherit (config.git) name email;
in
{
  enable = true;
  lfs.enable = true;
  userName = name;
  userEmail = email;
  extraConfig = {
    gpg.format = "ssh";
    init = {
      defaultBranch = "main";
    };
    credential = {
      helper = "store";
    };
  };
  delta = {
    enable = true;
    options = {
      line-number = true;
      side-by-side = true;
      syntax-theme = config.gui.theme.colors.batTheme;
      whitespace-error-style = "22 reverse";
      features = "decorations";
      interactive = {
        keep-plus-minus-markers = false;
      };
      decorations = {
        commit-decoration-style = "bold yellow box ul";
        file-style = "bold yellow ul";
        file-decoration-style = "none";
        hunk-header-decoration-style = "yellow box";
      };
    };
  };
  aliases = {
    s = "status";
    b = "branch";
    pm = "push origin main";
    pp = "push origin";
    lg = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all";
  };
}
