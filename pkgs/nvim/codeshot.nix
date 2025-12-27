{ pkgs }:
pkgs.vimUtils.buildVimPlugin {
  pname = "codeshot.nvim";
  version = "7c6347a4ea97e82f6dc508e6249150181d7b86be";
  src = pkgs.fetchFromGitHub {
    owner = "SergioRibera";
    repo = "codeshot.nvim";
    rev = "7c6347a4ea97e82f6dc508e6249150181d7b86be";
    sha256 = "sha256-+uZtyQp9tsig08AZB4W9M5gaUCRUAnyANmJM3Rq4V3I=";
  };
  meta.homepage = "https://github.com/SergioRibera/codeshot.nvim";
}
