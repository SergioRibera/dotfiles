{ pkgs, ... }: {
    enable = true;
    userName = "Sergio Ribera";
    userEmail = "56278796+SergioRibera@users.noreply.github.com";
    init = {
        defaultBranch = "main";
    };
    core = {
        pager = "delta";
    };
    credential = {
        helper = "store";
    };
    interactive = {
        diffFilter = "delta --color-only --features=interactive";
    };
    delta = {
        enable = true;
        options = {
            line-number = true;
            side-by-side = true;
            syntax-theme = "gruvbox-dark";
            whitespace-error-style = "22 reverse";
            features = [ "decorations" "unobtrusive-line-number" ];
            interactive = {
                keep-plus-minus-markers = false;
            };
            decorations = {
                commit-decoration-style = "bold yellow box ul";
                file-style = "bold yellow ul";
                file-decoration-style = "none";
                hunk-header-decoration-style = "yellow box";
            };
        };
    };
    aliases = {
        s = "status";
        b = "branch";
        pm = "push origin main";
        pp = "push origin";
        lg = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all";
    };
}
