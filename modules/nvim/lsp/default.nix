{pkgs, ...}: let
    lsp = builtins.readFile ./lsp.lua;
    lua_ls = builtins.readFile ./lua_ls.lua;
    tsserver = builtins.readFile ./tsserver.lua;
    # omnisharp = builtins.readFile ./omnisharp.lua;
    rust_analyzer = builtins.readFile ./rust_analyzer.lua;
in with pkgs.vimPlugins; {
    plugin = nvim-lspconfig;
    type = "lua";
    config = lsp + lua_ls + tsserver + rust_analyzer;
}
