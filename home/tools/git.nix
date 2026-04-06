{ config, lib, pkgs, ... }:
let
  inherit (config) user age;
  inherit (age) secrets;
  inherit (config.git) name email;
in
{
  home-manager.users.${user.username} = lib.mkIf user.enableHM (
    { lib, ... }:
    {
      home.activation.addSshKey = lib.hm.dag.entryAfter ["writeBoundary"] ''
        ${pkgs.openssh}/bin/ssh-add ${secrets.git_sign.path} || true
      '';
      programs = {
        delta = {
          enable = true;
          enableGitIntegration = true;
          options = {
            line-number = true;
            side-by-side = true;
            syntax-theme = config.gui.theme.colors.batTheme;
            whitespace-error-style = "22 reverse";
            features = "decorations";
            interactive.keep-plus-minus-markers = false;
            decorations = {
              commit-decoration-style = "bold yellow box ul";
              file-style = "bold yellow ul";
              file-decoration-style = "none";
              hunk-header-decoration-style = "yellow box";
            };
          };
        };
        git = {
          enable = true;
          lfs.enable = true;
          ignores = [
            "*result*"
            "node_modules"
          ];
          settings = {
            user = {
              inherit name email;
              signingkey = secrets.git_sign_pub.path;
            };
            alias = {
              s = "status";
              b = "branch";
              p = "push";
              lg = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all";
            };
            gpg.format = "ssh";
            init.defaultBranch = "main";
            credential.helper = "store";
            commit.gpgsign = true;
            push = {
              autoSetupRemote = true;
              default = "current";
            };
          };
        };
      };
    }
  );
}
