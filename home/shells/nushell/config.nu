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

$env.config = {
	show_banner: false,
}
