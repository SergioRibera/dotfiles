{ config, pkgs, lib, ... }: let
  lsp-raw = import ./lsp.nix { inherit config pkgs lib; };
  lsp = (lib.removeAttrs lsp-raw ["__functor"]);
in {
  home-manager.users."${config.user.username}" = lib.mkIf config.gui.enable {
    xdg.configFile."zed/tasks.json" = lib.mkIf config.gui.enable { source = ./tasks.jsonc; };
    programs.zed-editor = {
      enable = true;
      extensions = [
        "astro" "biome" "html"
        "liquid" # TODO: lsp
        "nix" "nu" "vue"
        "toml" "dockerfile" # "wakatime"
        "vitesse" # "discord-presence"
        "catppuccin-icons"
      ];
      extraPackages = with pkgs; [
        # LSP
        nixd
        biome
        nodejs
        # wakatime-ls
        # wakatime-cli
        taplo-lsp
        # discord-presence
        vue-language-server
        typescript-language-server
        vscode-langservers-extracted
        dockerfile-language-server-nodejs
      ];
      userKeymaps = (import ./keymaps.nix);
      userSettings = {
        auto_update = false;
        load_direnv = "direct";
        ui_font_size = 16;
        buffer_font_size = 14;
        format_on_save = "on";
        scrollbar.show = "never";
        autosave = "on_focus_change";
        relative_line_numbers = true;
        jupyter.enabled = false;
        vim_mode = true;
        theme = {
          mode = "system";
          dark = "Vitesse Dark Soft";
          light = "Vitesse Dark Soft";
        };
        indent_guides = {
          enabled = true;
          coloring = "indent_aware";
        };
        icon_theme = {
          mode = "system";
          light = "Catppuccin Frappé";
          dark = "Catppuccin Frappé";
        };
        toolbar = {
          breadcrumbs = true;
          quick_actions = false;
        };
        calls = {
          mute_on_join = true;
          share_on_join = false;
        };
        tabs = {
          git_status = true;
          file_icons = true;
        };
        inlay_hints = {
          enabled = true;
          show_type_hints = false;
          show_parameter_hints = true;
          show_other_hints = true;
        };
      } // lsp;
    };
  };
}
