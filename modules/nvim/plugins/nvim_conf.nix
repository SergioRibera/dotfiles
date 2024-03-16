{pkgs, ...}:
let 
    nvim-conf = pkgs.vimUtils.buildVimPlugin {
        pname = "nvim-conf";
        version = "2021-11-6";
        src = pkgs.fetchFromGitHub {
            owner = "SergioRibera";
            repo = "nvim-conf";
            rev = "28105f7587aaecff35cf379bcbd4c06e3f9d84d8";
            sha256 = "";
        };
        meta.homepage = "https://github.com/SergioRibera/nvim-conf";
    };
in {
    plugin = nvim-conf;
    type = "lua";
}
