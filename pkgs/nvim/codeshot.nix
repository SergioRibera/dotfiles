{ pkgs }: pkgs.vimUtils.buildVimPlugin {
  pname = "codeshot.nvim";
  version = "5750d07a92cb4451b70f2624025204467cd2c05e";
  src = pkgs.fetchFromGitHub {
    owner = "SergioRibera";
    repo = "codeshot.nvim";
    rev = "5750d07a92cb4451b70f2624025204467cd2c05e";
    sha256 = "sha256-i8RSk1wxMN5TI2oQcPyDmr9FYouBS2n4CYe60ao3oyM=";
  };
  meta.homepage = "https://github.com/SergioRibera/codeshot.nvim";
}
