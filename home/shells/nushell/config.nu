export def ga [...paths: path] {
  if ($paths | length) == 0 {
    git add -A
  } else {
    git add ...$paths
  }
}

export def gc [comment: string, ...paths: path] {
  if ($paths | length) == 0 {
    git add -A
  } else {
    git add ...$paths
  }

  sc -m $comment
}

export def gm [...paths: path] {
  if ($paths | length) == 0 {
    git add -A
  } else {
    git add ...$paths
  }

  git commit --amend --no-edit
}

export def gundo [count?: int] {
  if ($count == null) {
    git reset --soft HEAD~1
  } else {
    git reset --soft HEAD~$count
  }
}

export def batdiff [...files: path] { diff ...$files | bat --language=diff }

export def get-output [reason: string] {
  if not ("XDG_SESSION_DESKTOP" in $env) {
    return []
  }
  let outputs = if $env.XDG_SESSION_DESKTOP == "sway" {
    swaymsg -r -t get_outputs | from json | values | each {|el| { name: $el.name, display: $"($el.id) (ansi purple)($el.name)(ansi reset) - (ansi blue)($el.make)(ansi reset)" }}
  } else {
    niri msg --json outputs | from json | values | each {|el| { name: $el.name, display: $"(ansi purple)($el.name)(ansi reset) - (ansi blue)($el.make)(ansi reset)" }}
  }
  $outputs | input list -d display --fuzzy $"Select Output \(($reason)):" | get name
}

export def mirror-screen [] {
  let outputMirror = get-output "Screen to Mirror";
  let output = get-output "Where Put";
  wl-mirror -- -c --fullscreen-output $"$($outputMirror)" $"$($output)"
}

def _direnv [] {
  let rc_file = $"(pwd)/.envrc" | path exists
  if (which direnv | is-empty) or not $rc_file {
    return
  }

  direnv export json | from json | default {} | load-env
}

$env.config = {
  show_banner: false,
  history: {
      max_size: 100_000,
      sync_on_enter: true,
      file_format: "sqlite",
      isolation: false,
  }
  completions: {
    case_sensitive: false,
    quick: true,
    partial: true,
    algorithm: "fuzzy",
  }

  hooks: {
      env_change: {
          PWD: {|before, after| ($before != $after) and (_direnv)}
      }
  }
}

source ./carapace.nu
source ./ggit.nu
