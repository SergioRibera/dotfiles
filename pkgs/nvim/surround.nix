{ pkgs }: pkgs.vimUtils.buildVimPlugin {
  pname = "nvim-surround";
  version = "2024-06-02";
  src = pkgs.fetchFromGitHub {
    owner = "kylechui";
    repo = "nvim-surround";
    rev = "ec2dc7671067e0086cdf29c2f5df2dd909d5f71f";
    sha256 = "sha256-DCNfT//qMnzIu4V9or3Q39h4XzLz9P4twtHnQHV2rrQ=";
  };
  meta.homepage = "https://github.com/kylechui/nvim-surround";
}
