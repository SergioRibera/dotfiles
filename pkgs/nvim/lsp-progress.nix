{ pkgs }: pkgs.vimUtils.buildVimPlugin {
  pname = "lsp-progress.nvim";
  version = "2024-04-02";
  src = pkgs.fetchFromGitHub {
    owner = "linrongbin16";
    repo = "lsp-progress.nvim";
    rev = "47abfc74f21d6b4951b7e998594de085d6715791";
    sha256 = "sha256-flM49FBI1z7Imvk5wZW44N9IyLFRIswIe+bskOZ2CT0=";
  };
  meta.homepage = "https://github.com/linrongbin16/lsp-progress.nvim";
}
