{ pkgs }: pkgs.vimUtils.buildVimPlugin {
  pname = "lsp-progress.nvim";
  version = "v1.0.13";
  src = pkgs.fetchFromGitHub {
    owner = "linrongbin16";
    repo = "lsp-progress.nvim";
    rev = "v1.0.13";
    sha256 = "0h63z55gwv36rahhha8vkbxb9n4f8psa265khz719i97j17x39rr";
  };
  meta.homepage = "https://github.com/linrongbin16/lsp-progress.nvim";
}