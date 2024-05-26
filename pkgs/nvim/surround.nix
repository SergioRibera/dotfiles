{ pkgs }: pkgs.vimUtils.buildVimPlugin {
  pname = "nvim-surround";
  version = "2024-04-11";
  src = pkgs.fetchFromGitHub {
    owner = "kylechui";
    repo = "nvim-surround";
    rev = "f7bb9fc4d68ad319d94b1d98ed16f279811f5cc8";
    sha256 = "sha256-zi6FtK//HlBhndEYmzUQQtHR4ix73eAxHyB2Z3kmQz8=";
  };
  meta.homepage = "https://github.com/kylechui/nvim-surround";
}
