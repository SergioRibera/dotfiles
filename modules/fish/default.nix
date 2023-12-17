{pkgs, ...}: {
    enable = true;
    interactiveShellInit = builtins.readFile ./config.fish;
    # shellAliases = {
    #     neovide = "neovide --multigrid";
    # };
    functions = {
        __fish_cmd_error = {
            body = ''
# TODO: make more interactive
# crkbd_gui --no-gui -t 500ms color "00FFFF" "BFFFFF" full &>/dev/null
            '';
        };
        __fish_cmd_success = {
            body = ''
# TODO: make more interactive
# crkbd_gui --no-gui -t 500ms color "00FFFF" full &>/dev/null
            '';
        };
    };
}
