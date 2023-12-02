
alias ll='exa -lh --icons --group-directories-first'
alias la='exa -a --icons --group-directories-first'
alias lla='exa -lah --icons'
alias llag='exa -lah --git --icons'
alias ls='exa -Gx --icons --group-directories-first'
alias lsr='exa -Tlxa --icons --group-directories-first'
alias lsd='exa -GDx --icons --color always'
alias cat='bat'
alias catn='/usr/bin/cat'
alias neovide='neovide --multigrid'
alias paru "paru --skipreview --norebuild --noredownload"
alias cdwork "cd ~/Jooycar"
alias buildapk "docker run --rm -v $(pwd):/root/src -w /root/src notfl3/cargo-apk cargo quad-apk build --release"
