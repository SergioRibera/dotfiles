{pkgs, ...}:
    let hyprshot = pkgs.fetchFromGitHub {
        owner  = "Gustash";
        repo   = "Hyprshot";
        rev    = "36dbe2e6e97fb96bf524193bf91f3d172e9011a5";
        sha256 = "";
      };
    in {

        environment.systemPackages = with pkgs; [ grim slurp wl-clipboard hyprshot ];

        programs = {
            thunar.enable = true;
            ssh.startAgent = true;
            fish.enable = true;

            hyprland = {
                enable = true;
            };

            neovim = {
                enable = true;
                defaultEditor = true;
                viAlias = true;
                vimAlias = true;
            };

            firefox = {
                enable = true;
                preferencesStatus = "user";
                # package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
                #     preferencesStatus = "user";
                # };
                # profiles = {
                #     s4rch = {
                #         id = 0;
                #         name = "Sergio Ribera";
                #         extensions = with pkgs.nur.repos.rycee.firefox-addons; [
                #             ublock-origin
                #             bitwarden
                #             react-devtools
                #         ];
                #     }
                # };
            };
        };
}
