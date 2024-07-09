export def gc [comment: string, ...paths: path] {
  if ($paths | length) == 0 {
    git add -A
  } else {
    git add ...$paths
  }

  git commit -m $comment
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
}

source ./carapace.nu
