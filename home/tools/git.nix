{ config, lib, pkgs, ... }:
let
  inherit (config) user age;
  inherit (age) secrets;
  inherit (config.git) name email;
in
{
  systemd.user.services.ssh-add-git-sign = {
    enable = true;
    description = "Add git signing SSH key to agent";
    after = [ "default.target" ];
    wantedBy = [ "default.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "ssh-add-git-sign" ''
        if [ "$USER" != "${user.username}" ]; then
          exit 0
        fi
        NUON_FILE="/tmp/ssh-agent-$USER.nuon"

        if [ -f "$NUON_FILE" ]; then
          SSH_AUTH_SOCK=$(grep -oP 'SSH_AUTH_SOCK:\s*"\K[^"]+' "$NUON_FILE")
          SSH_AGENT_PID=$(grep -oP 'SSH_AGENT_PID:\s*"\K[^"]+' "$NUON_FILE")
          if ! kill -0 "$SSH_AGENT_PID" 2>/dev/null; then
            rm "$NUON_FILE"
          else
            export SSH_AUTH_SOCK SSH_AGENT_PID
          fi
        fi

        if [ ! -f "$NUON_FILE" ]; then
          eval $(${pkgs.openssh}/bin/ssh-agent -s)
          printf '{ SSH_AUTH_SOCK: "%s", SSH_AGENT_PID: "%s" }\n' \
            "$SSH_AUTH_SOCK" "$SSH_AGENT_PID" > "$NUON_FILE"
        fi

        exec ${pkgs.openssh}/bin/ssh-add ${secrets.git_sign.path}
      '';
      RemainAfterExit = true;
    };
  };

  home-manager.users.${user.username} = lib.mkIf user.enableHM (
    { ... }:
    {
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
