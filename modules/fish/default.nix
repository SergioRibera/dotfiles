{pkgs, ...}: {
    enable = true;
    interactiveShellInit = builtins.readFile ./config.fish;
    shellAliases = {
        neovide = "neovide --multigrid";
    };
}
