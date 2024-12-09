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
          PWD: {|before, after| ($before != $after) and $after | append (_direnv)}
      }
  }
}

source ./carapace.nu
source ./ggit.nu
