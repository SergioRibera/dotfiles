{ pkgs }:
pkgs.vimUtils.buildVimPlugin {
  pname = "cmp-dotenv.nvim";
  version = "4dd53aab60982f1f75848aec5e6214986263325e";
  src = pkgs.fetchFromGitHub {
    owner = "SergioRibera";
    repo = "cmp-dotenv";
    rev = "4dd53aab60982f1f75848aec5e6214986263325e";
    sha256 = "0pkkxfwsmp2rn77x8jbsb1j0avjx813n5kp4q6f0v0rfmjxk538i";
  };
  meta.homepage = "https://github.com/SergioRibera/cmp-dotenv";
}
