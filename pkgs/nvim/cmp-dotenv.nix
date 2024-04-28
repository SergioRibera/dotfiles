{ pkgs }: pkgs.vimUtils.buildVimPlugin {
  pname = "cmp-dotenv.nvim";
  version = "2023-12-26";
  src = pkgs.fetchFromGitHub {
    owner = "SergioRibera";
    repo = "cmp-dotenv";
    rev = "7af67e7ed4fd9e5b20127a624d22452fbd505ccd";
    sha256 = "sha256-/aQlOE92LPSSv+X968MDw8Mb1Yy4SeqS5xVb4PTBbcw=";
  };
  meta.homepage = "https://github.com/SergioRibera/cmp-dotenv";
}
