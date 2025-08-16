{ pkgs }: pkgs.vimUtils.buildVimPlugin {
  pname = "codeshot.nvim";
  version = "7c6347a4ea97e82f6dc508e6249150181d7b86be";
  src = pkgs.fetchFromGitHub {
    owner = "SergioRibera";
    repo = "codeshot.nvim";
    rev = "7c6347a4ea97e82f6dc508e6249150181d7b86be";
    sha256 = "sha256-i8RSk1wxMN5TI2oQcPyDmr9FYouBS2n4CYe60ao3oyM=";
  };
  meta.homepage = "https://github.com/SergioRibera/codeshot.nvim";
}
