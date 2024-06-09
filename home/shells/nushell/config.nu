export def gc [comment: string, ...paths: path] {
  if ($paths | length) == 0 {
    git add -A
  } else {
    git add $paths
  }

  git commit -m $comment
}

export def gm [...paths: path] {
  if ($paths | length) == 0 {
    git add -A
  } else {
    git add $paths
  }

  git commit --amend --no-edit
}

$env.config = {
	show_banner: false,
  completions: {
    case_sensitive: false,
    quick: true,
    partial: true,
    algorithm: "fuzzy",
    external: {
      enable: true,
      max_results: 100,
      # completer: $carapace_completer # check 'carapace_completer'
    }
  }
}
