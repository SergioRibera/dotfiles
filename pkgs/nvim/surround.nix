{ pkgs }: pkgs.vimUtils.buildVimPlugin {
  pname = "nvim-surround";
  version = "v2.3.1";
  src = pkgs.fetchFromGitHub {
    owner = "kylechui";
    repo = "nvim-surround";
    rev = "v2.3.1";
    sha256 = "1d5ffrsl1ryiq8nzxx7k69gpin6zs2ys4zc5pg47qcpazx7my8qc";
  };
  meta.homepage = "https://github.com/kylechui/nvim-surround";
}