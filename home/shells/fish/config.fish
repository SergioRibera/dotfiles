set -Ux fish_user_paths "$HOME/bin:/usr/local/bin:$HOME/.local/bin:$HOME/.cargo/bin"

# Remove startup banner
set fish_greeting

function promt_status -S -a last_status
    set -l nonzero
    set -l superuser
    set -l user_char_color 'normal'
    set -l user_char '  '
    set -l std_color 'blue'

     # Last exit was nonzero
    [ $last_status -ne 0 ]
    and set nonzero 1

    # If superuser (uid == 0)
    [ -w / -o -w /private/ ]
    and [ (id -u) == 0 ]
    and set superuser 1

    switch (uname)
        case Darwin
          set user_char '  '
        case '*'
          set user_char '  '
    end

    # User Input row
    # Detect errors or other
    set_color normal
    if [ "$nonzero" -o "$superuser" ]
        if [ "$nonzero" ]
            set std_color 'red'
            fish -c "__fish_cmd_error" &
        else
            set std_color 'blue'
            fish -c "__fish_cmd_success" &
        end

        if [ "$superuser" ]
            set user_char_color 'red'
            # set user_char " ☠ "
            set user_char "  "
        end
    end

    if [ "$fish_private_mode" ]
        set user_char_color '#D485AD'
        set user_char " 󰊪 "
    end

    if [ -n "$SSH_CLIENT" ]
        set user_char "  "
    end

    if [ -n "$IN_NIX_SHELL" ]
      set user_char_color '#82BCE5'
      set user_char "  "
    end

    set_color --bold $user_char_color
    echo -n -s \n$user_char
    set_color --bold $std_color
    echo -n "❯ "
end

function fish_prompt
    set -l last_status $status

    # Data row
    echo -n -s \n(set_color --bold green)\ (whoami)(set_color normal):\ \
        (set_color blue)(prompt_pwd)(set_color normal)\

    _is_git_folder; and _prompt_git

    # Status flags and input mode
    promt_status $last_status
    set_color normal
end

##############################
#
#
#       Git Section
#
#
##############################
set -g ORANGE                     FF8C00   # dark orange, FFA500 orange
set -g ICON_VCS_UNTRACKED         ""
set -g ICON_VCS_UNMERGED          ""
set -g ICON_VCS_MODIFIED          ""
set -g ICON_VCS_STAGED            ""
set -g ICON_VCS_DELETED           "✘"
set -g ICON_VCS_RENAME            "󱅅"
set -g ICON_VCS_STASH             ""
set -g ICON_VCS_BRANCH            "󰘬"
set -g ICON_VCS_PUSH              ""
set -g ICON_VCS_DIRTY             "±"

function _is_git_folder -d "Check if current folder is a git folder"
    git status 1>/dev/null 2>/dev/null
end

function _prompt_git -a current_dir -d 'Display the actual git state'
    set -l dirty (command git diff --no-ext-diff --quiet --exit-code; or echo -n ' ')
    set -l branch (git branch --show-current)

    echo -n " $ICON_VCS_BRANCH "(set_color magenta)"$branch"(set_color normal)\
        (_git_status)
end

function _git_status -d 'Check git status'
    set -l git_status (command git status --porcelain 2> /dev/null | cut -c 1-2)
    if [ (echo -sn $git_status\n | grep -E -c "[ACDMT][ MT]|[ACMT]D") -gt 0 ] #added
        echo -n (set_color green)$ICON_VCS_STAGED
    end
    if [ (echo -sn $git_status\n | grep -E -c "[ ACMRT]D") -gt 0 ] #deleted
        echo -n (set_color red)$ICON_VCS_DELETED
    end
    if [ (echo -sn $git_status\n | grep -E -c ".[MT]") -gt 0 ] #modified
        echo -n (set_color $ORANGE)$ICON_VCS_MODIFIED
    end
    if [ (echo -sn $git_status\n | grep -E -c "R.") -gt 0 ] #renamed
        echo -n (set_color purple)$ICON_VCS_RENAME
    end
    if [ (echo -sn $git_status\n | grep -E -c "AA|DD|U.|.U") -gt 0 ] #unmerged
        echo -n (set_color brred)$ICON_VCS_UNMERGED(set_color normal)
    end
    if [ (echo -sn $git_status\n | grep -E -c "\?\?") -gt 0 ] #untracked (new) files
        echo -n (set_color brcyan)$ICON_VCS_UNTRACKED
    end
    if test (command git rev-parse --verify --quiet refs/stash >/dev/null) #stashed (was '$')
        echo -n (set_color brred)$ICON_VCS_STASH
    end
end
