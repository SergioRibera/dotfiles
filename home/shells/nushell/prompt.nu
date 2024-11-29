def is_ssh_session [] {
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

def custom_path [] {
  let curr = pwd | str replace -r "/home/\\w+" "~" | split row "/"

  return ($curr | reverse | enumerate | each {|p| if $p.index != 0 { str substring 0..1 item } else { $p }} | get item | reverse | str join '/')
}

def git_prompt [] {
  # very perform alternative if we are on ignored folder
  if 'GITSTATUS_IGNORE_PATH' in $env and ($env.GITSTATUS_IGNORE_PATH | split row ";" | any {|el| $el == (pwd) }) {
    let branch = git rev-parse --abbrev-ref HEAD
    return $"󰘬 (ansi magenta)($branch)"
  }

  let stat = try {
    gstat
  } catch {
    return ''
  }

  if $stat.repo_name == "no_repository" {
    return ''
  }

  # let branch = if $stat.tag != "no_tag" {
  #   ["", $stat.tag]
  # } else {
  #   ["󰘬", $stat.branch]
  # }
  let branch = $"󰘬 (ansi magenta)($stat.branch)"
  let untracked = if $stat.wt_untracked >= 1 { $"(ansi { fg: c }) " } else { "" }
  let stash     = if $stat.stashes >= 1 { $"(ansi { fg: r }) " } else { "" }
  let staged    = if $stat.idx_added_staged >= 1 { $"(ansi { fg: g })" } else { "" }
  let unmerged  = if $stat.conflicts >= 1 { $"(ansi { fg: r }) " } else { "" }
  let modified  = if $stat.wt_modified >= 1 { $"(ansi '#FF8C00') " } else { "" } # ±
  let rename    = if $stat.wt_renamed >= 1 { $"(ansi { fg: p })󱅅 " } else { "" }
  let deleted   = if $stat.wt_deleted >= 1 { $"(ansi { fg: r })✘" } else { "" }
  let push      = if $stat.ahead >= 1 { $"(ansi { fg: u }) " } else { "" }

  return $"($branch) ($stash)($untracked)($staged)($unmerged)($modified)($rename)($deleted)($push)(ansi reset)"
}

def prompt [] {
    print -n $"\n(ansi { fg: green, attr: b }) (whoami)(ansi reset): (ansi blue)(custom_path) (ansi reset)(git_prompt)"
}

# Define a custom prompt function
def prompt_status [indicator_ty: string] {
    let last_status = $env.LAST_EXIT_CODE
    let nonzero = $last_status != 0
    let superuser = (id -u) == 0
    let in_nix_shell = "IN_NIX_SHELL" in $env
    let in_distrobox = "DISTROBOX_HOST_HOME" in $env
    let user_char_color = if $superuser {
      "red"
    } else if not $nu.history-enabled {
      "#D485AD"
    } else if $in_nix_shell {
      "#82BCE5"
    } else {
      "normal"
    }
    let user_char = try {
      let name = (uname | get kernel-name)
      if $superuser { # is root
        "☠"
      } else if (is_ssh_session) { # conected to ssh
        ""
      } else if not $nu.history-enabled { # private mode
        "󰊪"
      } else if $in_nix_shell { # in nix shell
        ""
      } else if $in_distrobox { # in distrobox
        ""
      } else if $name == "Darwin" { # is running on mac
        ""
      } else { # else is linux
        ""
      }
    } catch { # Windows ???
      ""
    }

    let std_color = if $last_status != 0 {
      "red"
    } else {
      "blue"
    }

    let indicator = match indicator_ty {
      "vi" => ":", # Vim Insert
      "vn" => ">", # Vim Normal
      "ml" => ":::", # Multiline
      _ => "❯", # Others
    }

    return $"(ansi { fg: $user_char_color, attr: b }) ($user_char)(ansi { fg: $std_color, attr: b }) ($indicator) "
}
