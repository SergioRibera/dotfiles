{ pkgs, ... }:
let
  NOC = "\\033[0m";             # Text Reset
  ITALIC = "\\e[3m";            # Italic text
  BOLDBLACK="\\033[1;30m";      # Black
  BBLUE = "\\033[1;34m";        # Blue
  BGLIGHTBLUT = "\\e[104m";     # LightBlue
  BGPURPLE = "\\033[45m";       # Purple
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
      echo -e "\t  • ${BGPURPLE} rebuild ${NOC} ${ITALIC}Switch to this configuration.${NOC}"
      echo -e "\t  • ${BGPURPLE} neovim ${NOC} ${ITALIC}Run out the complete Neovim package.${NOC}"
      echo -e "\t  • ${BGPURPLE} neovim-basic ${NOC} ${ITALIC}Run out the basic Neovim package.${NOC}"
      echo -e "\t  • ${BGPURPLE} update-pkgs ${NOC} ${ITALIC}Upgrades all custom package sources.${NOC}"
    ''
  );
}
