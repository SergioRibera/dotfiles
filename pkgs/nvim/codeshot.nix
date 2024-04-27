{ pkgs }: pkgs.vimUtils.buildVimPlugin {
  pname = "codeshot.nvim";
  version = "2023-12-26";
  src = pkgs.fetchFromGitHub {
    owner = "SergioRibera";
    repo = "codeshot.nvim";
    rev = "4931944474a7c3d99ba97ca5c7e81ade1a199f10";
    sha256 = "sha256-kvyiYsZV6BqGzkFa7moE9DAitP0uIM9yDQh378SGAjU=";
  };
  meta.homepage = "https://github.com/SergioRibera/codeshot.nvim";
}
