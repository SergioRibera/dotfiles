def update-git-status [
    status: record
    m: string
] {
    if $m == 'A' {
        ($status | update a (($status.a | into int) + 1))
    } else if $m == 'M' {
        ($status | update m (($status.m | into int) + 1))
    } else if $m == 'D' {
        ($status | update d (($status.d | into int) + 1))
    } else {
        $status
    }
}

#
# Helper
#
def in_git_repo [] {
  (do --ignore-errors { git rev-parse --abbrev-ref HEAD } | is-empty) == false
}

def get-username [] {
    if 'USERNAME' in $env {
        $env.USERNAME
    } else if 'USER' in $env {
        $env.USER
    } else {
        ''
    }
}

def is-ssh-session [] {
    if 'SSH_CONNECTION' in $env {
        true
    } else if 'SSH_CLIENT' in $env {
        true
    } else if 'SSH_TTY' in $env {
        true
    } else {
        false
    }
}

# Define a custom prompt function
def prompt_status [last_status: int] {
    let nonzero = $last_status != 0
    mut superuser = false
    mut user_char_color = "normal"
    mut user_char = "  "
    mut std_color = "blue"

    # Last exit was nonzero
    if $last_status != 0 {
        let nonzero = true
    }

    # If superuser (uid == 0)
      if (id -u) == 0 {
          $superuser = true
      }

    # Detect OS and set user_char accordingly
    match (sys | get host.name) {
        "Darwin" => {
            $user_char = "  "
        }
        _ => {
            $user_char = "  "
        }
    }

    # User Input row
    # Detect errors or other
    if $nonzero or $superuser {
        if $nonzero {
            $std_color = "red"
            # run as error
        } else {
            $std_color = "blue"
            # run as ok
        }

        if $superuser {
            $user_char_color = "red"
            # user_char " ☠ "
            $user_char = "  "
        }
    }

    # Check private mode
    # if $env.FISH_PRIVATE_MODE {
    #     $user_char_color = "#D485AD"
    #     $user_char = " 󰊪 "
    # }

    if "SSH_CLIENT" in $env {
        $user_char = "  "
    }

    if "IN_NIX_SHELL" in $env {
        $user_char_color = "#82BCE5"
        $user_char = "  "
    }

    print -n (ansi { fg: $user_char_color, attr: b }) $user_char
    print -n (ansi { fg: $std_color, attr: b }) "❯ "
}

def prompt [] {
    let last_status = $env.LAST_EXIT_CODE

    # Data row
    print -n "\n" (ansi { fg: green, attr: b }) " " (whoami) (ansi green) ":" (ansi blue) (pwd) (ansi reset)

    # Check if in a git folder and show git status if true
    # if (is_git_repo) {
    #     _prompt_git
    # }

    # Status flags and input mode
    prompt_status $last_status
    ansi reset
}

$env.config = {
	show_banner: false,
}
