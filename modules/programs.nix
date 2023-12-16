_: {
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
