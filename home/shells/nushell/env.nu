
# Set the prompt to use the custom function
$env.PROMPT_COMMAND = { prompt }
$env.PROMPT_COMMAND_RIGHT = ""
$env.PROMPT_INDICATOR = ""


nuls = ls
alias ll = eza -lh --icons --group-directories-first
alias la = eza -a --icons --group-directories-first
alias lla = eza -lah --icons
alias llag = eza -lah --git --icons
alias ls = eza -Gx --icons --group-directories-first
alias lsr = eza -Tlxa --icons --group-directories-first
alias lsd = eza -GDx --icons --color always
alias cat = bat
alias catn = bat --plain
alias catnp = bat --plain --paging=never
alias ga = git add -A && git commit -m
alias gs = git s
alias gb = git switch
alias gp = git p
alias gbc = git switch -c
alias glg = git lg
alias tree = eza --tree --icons=always
alias nixdev = nix develop -c 'fish'
alias nixclear = nix-store --gc
alias nixcleanup = sudo nix-collect-garbage --delete-older-than 1d
alias nixlistgen = sudo nix-env -p /nix/var/nix/profiles/system --list-generations
alias nixforceclean = sudo nix-collect-garbage -d
