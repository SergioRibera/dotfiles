{ pkgs }: pkgs.vimUtils.buildVimPlugin {
  pname = "cmp-dotenv.nvim";
  version = "2023-12-26";
  src = pkgs.fetchFromGitHub {
    owner = "SergioRibera";
    repo = "cmp-dotenv";
    rev = "e82cb22a3ee0451592e2d4a4d99e80b97bc96045";
    sha256 = "sha256-AmuFfbzQLSLkRT0xm3f0S4J+3XBpYjshKgjhhAasRLw=";
  };
  meta.homepage = "https://github.com/SergioRibera/cmp-dotenv";
}
