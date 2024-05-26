{ pkgs }: pkgs.vimUtils.buildVimPlugin {
  pname = "vim-wakatime";
  version = "2024-04-11";
  src = pkgs.fetchFromGitHub {
    owner = "wakatime";
    repo = "vim-wakatime";
    rev = "5d11a253dd1ecabd4612a885175216032d814300";
    sha256 = "sha256-1w6M6hnDOu4ruAUnUcAbFViUzZDGslrdYXx5jVrspc8=";
  };
  meta.homepage = "https://github.com/wakatime/vim-wakatime";
}
