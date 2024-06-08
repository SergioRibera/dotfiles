def custom_path [] {
  let curr = pwd | str replace -r "/home/\\w+/" "~/" | split row "/"

  return ($curr | reverse | enumerate | each {|p| if $p.index != 0 { str substring 0..1 item } else { $p }} | get item | reverse | str join '/')
}

def prompt [] {
    # Data row
    print -n "\n" (ansi { fg: green, attr: b }) " " (whoami) (ansi reset) ": " (ansi blue) (custom_path) (ansi reset)

    # Check if in a git folder and show git status if true
    # if (is_git_repo) {
    #     _prompt_git
    # }

    ansi reset
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

# If you want previously entered commands to have a different prompt from the usual one,
# you can uncomment one or more of the following lines.
# This can be useful if you have a 2-line prompt and it's taking up a lot of space
# because every command entered takes up 2 lines instead of 1. You can then uncomment
# the line below so that previously entered commands show with a single `🚀`.
# $env.TRANSIENT_PROMPT_COMMAND = {|| "🚀 " }
# $env.TRANSIENT_PROMPT_INDICATOR = {|| "" }
# $env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = {|| "" }
# $env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = {|| "" }
# $env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = {|| "" }
# $env.TRANSIENT_PROMPT_COMMAND_RIGHT = {|| "" }

alias nuls = ls
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
alias ga = git add -A and git commit -m
alias gs = git s
alias gb = git switch
alias gp = git p
alias gbc = git switch -c
alias glg = git lg
alias tree = eza --tree --icons=always
alias nixdev = nix develop -c "$SHELL"
alias nixclear = nix-store --gc
alias nixcleanup = sudo nix-collect-garbage --delete-older-than 1d
alias nixlistgen = sudo nix-env -p /nix/var/nix/profiles/system --list-generations
alias nixforceclean = sudo nix-collect-garbage -d

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

# To add entries to PATH (on Windows you might use Path), you can use the following pattern:
# $env.PATH = ($env.PATH | split row (char esep) | prepend '/some/path')
# An alternate way to add entries to $env.PATH is to use the custom command `path add`
# which is built into the nushell stdlib:
# use std "path add"
# $env.PATH = ($env.PATH | split row (char esep))
# path add /some/path
# path add ($env.CARGO_HOME | path join "bin")
# path add ($env.HOME | path join ".local" "bin")
# $env.PATH = ($env.PATH | uniq)

# To load from a custom file you can use:
# source ($nu.default-config-dir | path join 'custom.nu')
