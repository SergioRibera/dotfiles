set -Ux TerminalEmulator 'wezterm start'
set -Ux BROWSER 'microsoft-edge-dev'
set -Ux JAVA_HOME "/opt/android-studio/jre"
set -Ux ANDROID_SDK_ROOT "/home/s4rch/Android/Sdk/"
set -Ux fish_user_paths "$HOME/bin:/usr/local/bin:$HOME/.local/bin:$HOME/.cargo/bin"
# Remove startup banner
set fish_greeting

function error
    # TODO: make more interactive
    crkbd_gui --no-gui -t 2s color "00FFFF" "BFFFFF" full
end

function success
    # TODO: make more interactive
    crkbd_gui --no-gui -t 2s color "00FFFF" full
end

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

    # User Input row
    # Detect errors or other
    set_color normal
    if [ "$nonzero" -o "$fish_private_mode" -o "$superuser"]
        if [ "$nonzero" ]
            set std_color 'red'
            fish -c "error" &
        else
            set std_color 'blue'
            fish -c "success" &
        end

        if [ "$fish_private_mode" ]
            set user_char "  "
        end

        if [ "$superuser" ]
            set user_char_color 'red'
            # set user_char " ☠ "
            set user_char "  "
        end
    end

    if [ -n "$SSH_CLIENT" ]
        set user_char "  "
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
set -g ORANGE                     FF8C00        #FF8C00 dark orange, FFA500 orange, another one fa0 o
set -g ICON_VCS_UNTRACKED         \UF02C" "     #    #●: there are untracked (new) files
set -g ICON_VCS_UNMERGED          \UF026" "     #    #═: there are unmerged commits
set -g ICON_VCS_MODIFIED          \UF06D" "     # 
set -g ICON_VCS_STAGED            \UF06B" "     #  (added) →
set -g ICON_VCS_DELETED           "✘"           # 
set -g ICON_VCS_RENAME            \UF06E" "     # 
set -g ICON_VCS_STASH             \UF0CF" "     #✭: there are stashed commits
set -g ICON_VCS_BRANCH            "שׂ"
set -g ICON_VCS_PUSH              printf "\UF005 " # bugs out in fish: \UF005 (printf "\UF005")
set -g ICON_VCS_DIRTY             ±             #
set -g ICON_ARROW_UP              \UF03D""      #  ↑
set -g ICON_ARROW_DOWN            \UF03F""      #  ↓

function _is_git_folder -d "Check if current folder is a git folder"
    git status 1>/dev/null 2>/dev/null
end

function _prompt_git -a current_dir -d 'Display the actual git state'
    set -l dirty (command git diff --no-ext-diff --quiet --exit-code; or echo -n ' ')
    set -l branch (git branch --show-current)

    echo -n "$ICON_VCS_BRANCH "(set_color magenta)"$branch"(set_color normal)\
        (_git_status)
end

function _git_status -d 'Check git status'
    set -l git_status (command git status --porcelain 2> /dev/null | cut -c 1-2)
    if [ (echo -sn $git_status\n | egrep -c "[ACDMT][ MT]|[ACMT]D") -gt 0 ] #added
        echo -n (set_color green)$ICON_VCS_STAGED
    end
    if [ (echo -sn $git_status\n | egrep -c "[ ACMRT]D") -gt 0 ] #deleted
        echo -n (set_color red)$ICON_VCS_DELETED
    end
    if [ (echo -sn $git_status\n | egrep -c ".[MT]") -gt 0 ] #modified
        echo -n (set_color $ORANGE)$ICON_VCS_MODIFIED
    end
    if [ (echo -sn $git_status\n | egrep -c "R.") -gt 0 ] #renamed
        echo -n (set_color purple)$ICON_VCS_RENAME
    end
    if [ (echo -sn $git_status\n | egrep -c "AA|DD|U.|.U") -gt 0 ] #unmerged
        echo -n (set_color brred)$ICON_VCS_UNMERGED(set_color normal)
    end
    if [ (echo -sn $git_status\n | egrep -c "\?\?") -gt 0 ] #untracked (new) files
        echo -n (set_color brcyan)$ICON_VCS_UNTRACKED
    end
    if test (command git rev-parse --verify --quiet refs/stash >/dev/null) #stashed (was '$')
        echo -n (set_color brred)$ICON_VCS_STASH
    end
end
