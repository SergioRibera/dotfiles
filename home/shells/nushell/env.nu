def custom_path [] {
  let curr = pwd | str replace -r "/home/\\w+/" "~/" | split row "/"

  return ($curr | reverse | enumerate | each {|p| if $p.index != 0 { str substring 0..1 item } else { $p }} | get item | reverse | str join '/')
}

def git_prompt [] {
  let stat = gstat

  if $stat.repo_name == "no_repository" {
    return ''
  }

  let branch = if $stat.tag != "no_tag" {
    ["", $stat.tag]
  } else {
    ["󰘬", $stat.branch]
  }
  let untracked = if $stat.wt_untracked >= 1 { $"(ansi { fg: c })" } else { "" }
  let stash     = if $stat.stashes >= 1 { $"(ansi { fg: r })" } else { "" }
  let staged    = if $stat.idx_added_staged >= 1 { $"(ansi { fg: g })" } else { "" }
  let unmerged  = if $stat.conflicts >= 1 { $"(ansi { fg: r })" } else { "" }
  let modified  = if $stat.wt_modified >= 1 { $"(ansi '#FF8C00')±" } else { "" } # 
  let rename    = if $stat.wt_renamed >= 1 { $"(ansi { fg: p })󱅅" } else { "" }
  let deleted   = if $stat.wt_deleted >= 1 { $"(ansi { fg: r })✘" } else { "" }
  let push      = if $stat.ahead >= 1 { $"(ansi { fg: u })" } else { "" }

  return $"($branch.0) (ansi magenta)($branch.1) ($stash)($untracked)($staged)($unmerged)($modified)($rename)($deleted)($push)(ansi reset)"
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
      } else if "SSH_CLIENT" in $env { # conected to ssh
        ""
      } else if not $nu.history-enabled { # private mode
        "󰊪"
      } else if $in_nix_shell { # in nix shell
        ""
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

# Set the prompt to use the custom function
$env.PROMPT_COMMAND = {|| prompt }
$env.PROMPT_COMMAND_RIGHT = ""

# The prompt indicators are environmental variables that represent
# the state of the prompt
$env.PROMPT_INDICATOR = {|| prompt_status "" }
$env.PROMPT_INDICATOR_VI_INSERT = {|| prompt_status "vi" }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| prompt_status "vn" }
$env.PROMPT_MULTILINE_INDICATOR = {|| prompt_status "ml" }

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
$env.ENV_CONVERSIONS = {
    "PATH": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
    "Path": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
}

# Directories to search for scripts when calling source or use
# The default for this is $nu.default-config-dir/scripts
$env.NU_LIB_DIRS = [
    ($nu.default-config-dir | path join 'scripts') # add <nushell-config-dir>/scripts
]

# Directories to search for plugin binaries when calling register
# The default for this is $nu.default-config-dir/plugins
$env.NU_PLUGIN_DIRS = [
    ($nu.default-config-dir | path join 'plugins') # add <nushell-config-dir>/plugins
]

