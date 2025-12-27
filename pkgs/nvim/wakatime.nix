{ pkgs }:
pkgs.vimUtils.buildVimPlugin {
  pname = "vim-wakatime";
  version = "11.3.0";
  src = pkgs.fetchFromGitHub {
    owner = "wakatime";
    repo = "vim-wakatime";
    rev = "11.3.0";
    sha256 = "0v21r1yj6s28vhqym200n33qgdrjwxjrpzjzkax81cbmmp6a6fbc";
  };
  meta.homepage = "https://github.com/wakatime/vim-wakatime";
}
