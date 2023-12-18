{pkgs, ...}: {
    plugins = [
        import ./lsp_progress.nix {inherit pkgs;}
        import ./nvim_conf.nix {inherit pkgs;}
    ];
}
