{ pkgs }: pkgs.vimUtils.buildVimPlugin {
  pname = "codeshot.nvim";
  version = "7e418c2b6e8b7aaa75d41c5c91d96a837251a18d";
  src = pkgs.fetchFromGitHub {
    owner = "SergioRibera";
    repo = "codeshot.nvim";
    rev = "7e418c2b6e8b7aaa75d41c5c91d96a837251a18d";
    sha256 = "1q4r2wy05hkbjvmfqmfxn7qqbzlvixj68ycvksll2rwbigmsgk64";
  };
  meta.homepage = "https://github.com/SergioRibera/codeshot.nvim";
}