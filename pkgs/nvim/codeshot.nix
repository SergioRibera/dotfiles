{ pkgs }: pkgs.vimUtils.buildVimPlugin {
  pname = "codeshot.nvim";
  version = "2023-12-26";
  src = pkgs.fetchFromGitHub {
    owner = "SergioRibera";
    repo = "codeshot.nvim";
    rev = "82fabc554c2a61c152def9f20c643b330418deb6";
    sha256 = "sha256-9VJEo3RfFp1IlKRBq/ai1VJhGiV0wuWmN8YQA6Y+O9Y=";
  };
  meta.homepage = "https://github.com/SergioRibera/codeshot.nvim";
}
