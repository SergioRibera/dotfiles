{ pkgs, ... }:
let
  NOC = "\\033[0m"; # Text Reset
  ITALIC = "\\e[3m"; # Italic text
  BOLDBLACK = "\\033[1;30m"; # Black
  BBLUE = "\\033[1;34m"; # Blue
  BGLIGHTBLUT = "\\e[104m"; # LightBlue
  BGPURPLE = "\\033[45m"; # Purple
in
{
  type = "app";

  program = builtins.toString (
    pkgs.writeShellScript "default" ''

      echo -e "\t${BBLUE}Options ${NOC}"
      echo ""
      echo -e "\tRun with ${BGLIGHTBLUT}${BOLDBLACK}nix run github:SergioRibera/dotfiles#${BGPURPLE}someoption${BGLIGHTBLUT}${NOC}."
      echo ""
      echo ""
      echo -e "\t  • ${BGPURPLE} install ${NOC} ${ITALIC}Install NixOS from the live installer.${NOC}"
      echo -e "\t  • ${BGPURPLE} rebuild ${NOC} ${ITALIC}Switch to this configuration.${NOC}"
      echo -e "\t  • ${BGPURPLE} update-pkgs ${NOC} ${ITALIC}Upgrades all custom package sources.${NOC}"
      echo -e "\t  • ${BGPURPLE} nvim ${NOC} ${ITALIC}Run full Neovim + Neovide.${NOC}"
      echo -e "\t  • ${BGPURPLE} nvim-basic ${NOC} ${ITALIC}Run headless Neovim (no GUI).${NOC}"
      echo -e "\t  • ${BGPURPLE} fish ${NOC} ${ITALIC}Fish shell with dotfiles config.${NOC}"
      echo -e "\t  • ${BGPURPLE} zellij ${NOC} ${ITALIC}Zellij with dotfiles config.${NOC}"
    ''
  );
}
