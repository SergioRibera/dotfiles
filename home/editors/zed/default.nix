{ config, pkgs, lib, ... }: let
  lsp = import ./lsp.nix { inherit config pkgs lib; };
  zedNodeFixScript = pkgs.writeShellScriptBin "zedNodeFixScript" ''
    nodeVersion="node-v${pkgs.nodejs.version}-linux-x64"
    zedNodePath="/home/${config.user.username}/zed/node/$nodeVersion"

    rm -rf $zedNodePath
    ln -sfn ${pkgs.nodejs} $zedNodePath
  '';
  jsonGenerator = lib.generators.toJSON {};
in {
  home-manager.users."${config.user.username}" = lib.mkIf config.gui.enable {
    home.packages = with pkgs; (lib.optionals config.gui.enable) [
      zed-editor
      zedNodeFixScript
      nixd
      biome
      nodejs
      taplo-lsp
      vue-language-server
      typescript-language-server
      vscode-langservers-extracted
      dockerfile-language-server-nodejs
    ];
    xdg.configFile."zed/keymap.json".source = ./keymap.jsonc;
    xdg.configFile."zed/tasks.json".source = ./tasks.jsonc;
    xdg.configFile."zed/settings.json".text = jsonGenerator ({
      # The extensions that Zed should automatically install on startup.
      auto_install_extensions = {
        astro = true;
        biome = true;
        html = true;
        liquid = true; # TODO: lsp
        nix = true;
        nu = true;
        vue = true;
        toml = true;
        dockerfile = true;
        vitesse = true;
        discord-presence = true;
      };
      auto_update = false;
      ui_font_size = 16;
      buffer_font_size = 14;
      format_on_save = "on";
      scrollbar.show = "never";
      autosave = "on_focus_change";
      relative_line_numbers = true;
      jupyter.enabled = false;
      vim_mode = true;
      formatter = {
        external = {
          command = "${pkgs.biome}/bin/biome";
          arguments = ["format" "--write" "--stdin-file-path" "{buffer_path}"];
        };
      };
      theme = {
        mode = "system";
        dark = "Vitesse Dark Soft";
        light = "Vitesse Dark Soft";
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
    } // (lib.removeAttrs lsp ["__functor"]));
  };
}
