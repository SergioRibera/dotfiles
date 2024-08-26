{ pkgs, config, lib, ... }: {
  environment.systemPackages = with pkgs; (lib.optionals config.gui.enable) [ zed-editor ];
}
