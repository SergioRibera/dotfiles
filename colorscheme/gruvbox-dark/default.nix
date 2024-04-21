# Gruvbox with a darker background for greater contrast
# Source: https://github.com/nmasur/dotfiles/blob/b23efc4d77fc76ac39752a3ccd56aabb98a9a558/colorscheme/gruvbox-dark/default.nix

{
  name = "gruvbox-dark"; # Dark, Medium
  author =
    "Dawid Kurek (dawikur@gmail.com), morhetz (https://github.com/morhetz/gruvbox), ElRastaOk (https://www.reddit.com/user/ElRastaOk)";
  dark = {
    base00 = "#262626"; # ---- This is the change from normal gruvbox
    base01 = "#3a3a3a"; # ---
    base02 = "#4e4e4e"; # --
    base03 = "#8a8a8a"; # -
    base04 = "#949494"; # +
    base05 = "#dab997"; # ++
    base06 = "#d5c4a1"; # +++
    base07 = "#ebdbb2"; # ++++
    base08 = "#d75f5f"; # red
    base09 = "#ff8700"; # orange
    base0A = "#ffaf00"; # yellow
    base0B = "#afaf00"; # green
    base0C = "#85ad85"; # aqua/cyan
    base0D = "#83adad"; # blue
    base0E = "#d485ad"; # purple
    base0F = "#d65d0e"; # brown
    batTheme = "gruvbox-dark";
  };
  light = {
    base00 = "#fbf1c7"; # ----
    base01 = "#ebdbb2"; # ---
    base02 = "#d5c4a1"; # --
    base03 = "#bdae93"; # -
    base04 = "#665c54"; # +
    base05 = "#504945"; # ++
    base06 = "#3c3836"; # +++
    base07 = "#1D2122"; # ++++ Adjusted darker here
    base08 = "#9d0006"; # red
    base09 = "#af3a03"; # orange
    base0A = "#b57614"; # yellow
    base0B = "#79740e"; # green
    base0C = "#427b58"; # aqua/cyan
    base0D = "#076678"; # blue
    base0E = "#8f3f71"; # purple
    base0F = "#d65d0e"; # brown
    batTheme = "gruvbox-light";
  };
}
