{ config, ... }: let
  mkFont = name: { family = name; };
in {
  home-manager.users.${config.user.username}.programs.rio = {
    enable = config.gui.enable && config.terminal == "rio";
    settings = {
      cursor = {
        # Other available options are: 'block', 'underline', 'beam'
        shape = "Beam";
        blinking = true;
      };
      # TODO: make custom theme into $HOME/.config/rio/themes/theme.toml
      # https://raphamorim.io/rio/docs/config/theme/
      # theme = "theme";
      padding-x = 5;
      # Defaults for POSIX-based systems (Windows is not configurable):
      use-fork = false;

      window = {
        opacity = 1.0;
        # • decorations - Set window decorations, options: "Enabled", "Disabled", "Transparent", "Buttonless"
        decorations = "Disabled";
      };
      renderer = {
        # • Performance: Set WGPU rendering performance
        #   - High: Adapter that has the highest performance. This is often a discrete GPU.
        #   - Low: Adapter that uses the least possible power. This is often an integrated GPU.
        performance = "High";
        # • Backend: Set WGPU rendering backend
        #   - Automatic: Leave Sugarloaf/WGPU to decide
        #   - GL: Supported on Linux/Android, and Windows and macOS/iOS via ANGLE
        #   - Vulkan: Supported on Windows, Linux/Android
        #   - DX12: Supported on Windows 10
        #   - Metal: Supported on macOS/iOS
        backend = "Automatic";
        # • disable-unfocused-render: This property disable renderer processes while Rio is unfocused.
        disable-unfocused-render = false;
      };
      fonts = {
        size = 14;
        family = "CaskaydiaCove Nerd Font";
        extras = [
          (mkFont "FiraCode Nerd Font")
          (mkFont "UbuntuMono Nerd Font")
          (mkFont "Noto Color Emoji")
        ];
      };
      # Scroll calculation for canonical mode will be based on `lines = (accumulated scroll * multiplier / divider)`
      scroll = {
        multiplier = 3.0;
        divider = 1.0;
      };
      navigation = {
        # "mode" - Define navigation mode
        #   • NativeTab (MacOS only)
        #   • BottomTab
        #   • TopTab
        #   • Bookmark
        #   • Plain
        mode = "Bookmark";
        clickable = true;
        use-split = true;
      };
      # https://raphamorim.io/rio/docs/config/bindings
      bindings.keys = [
        { key = "l"; "with" = "super | shift"; action = "SplitRigh"; }
        { key = "j"; "with" = "super | shift"; action = "SplitDown"; }
        { key = "n"; "with" = "super | shift"; action = "SplitDown | Run(nu --no-history)"; }
        { key = "t"; "with" = "super"; action = "CreateTab"; }
      ];
    };
  };
}
