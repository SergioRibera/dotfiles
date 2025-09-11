$env.GGIT_CONFIG_DIR =  if "XDG_DATA_HOME" in $env {
  $"($env.XDG_DATA_HOME)/ggit"
} else if "USER" in $env {
  $"/home/($env.USER)/.local/share/ggit"
} else if "LOCALAPPDATA" in $env {
  $"($env.LOCALAPPDATA)/ggit"
}


def get_paths [] {
    let config_path = $"($env.GGIT_CONFIG_DIR)/paths"
    if not ($env.GGIT_CONFIG_DIR | path exists) {
        mkdir $env.GGIT_CONFIG_DIR
    }
    if ($config_path | path exists) {
        return (open $config_path | lines)
    }
    let paths = []

    $paths | save $config_path

    return $paths
}

def show_stats [p: path] {
    let stat = gstat $p
    let branch = $"󰘬 (ansi magenta)($stat.branch)(ansi reset)"
    let untracked = if $stat.wt_untracked >= 1 { $"\n   (ansi { fg: c })Untracked(ansi reset): ($stat.wt_untracked)" } else { "" }
    let stash     = if $stat.stashes >= 1 { $"\n   (ansi { fg: r })In Stash(ansi reset): ($stat.stashes)" } else { "" }
    let staged    = if $stat.idx_added_staged >= 1 { $"\n   (ansi { fg: g })Staged(ansi reset): ($stat.idx_added_staged)" } else { "" }
    let unmerged  = if $stat.conflicts >= 1 { $"\n   (ansi { fg: r })Unmerged(ansi reset): ($stat.conflicts)" } else { "" }
    let modified  = if $stat.wt_modified >= 1 { $"\n   (ansi '#FF8C00')Modified(ansi reset): ($stat.wt_modified)" } else { "" } # ±
    let rename    = if $stat.wt_renamed >= 1 { $"\n   (ansi { fg: p })Renames(ansi reset): ($stat.wt_renamed)" } else { "" }
    let deleted   = if $stat.wt_deleted >= 1 { $"\n   (ansi { fg: r })Removed(ansi reset): ($stat.wt_deleted)" } else { "" }
    let push      = if $stat.ahead >= 1 { $"\n   (ansi { fg: u })To push(ansi reset): ($stat.ahead)" } else { "" }

    print $" - ($p) ($branch):($stash)($untracked)($staged)($unmerged)($modified)($rename)($deleted)($push)"
}

def "ggit list" [] {
    let paths = get_paths
    print "Global Git local Repos:\n"

    if ($paths | length) > 0 {
        $paths | each {|p| print $" - ($p)"}
        return
    }
    print " Empty"
}

def "ggit add" [root: path] {
    let config_path = $"($env.GGIT_CONFIG_DIR)/paths"
    let paths = get_paths | append (fd -H -t d ".git$" $root | lines | each {|p| $p | path dirname}) | uniq

    $paths | save -f $config_path
}

def "ggit check" [] {
    let paths = get_paths
    print "Global Git local Repos status:\n"

    if ($paths | length) == 0 {
        print " No Repos found, please use `ggit add <path>`"
        return
    }

    $paths | each { |p| show_stats $p }
    print ""
}

def "ggit dyn" [] {
    let paths = get_paths
    print "Global Git local Repos status:\n"

    if ($paths | length) == 0 {
        print " No Repos found, please use `ggit add <path>`"
        return
    }

    let p = ($paths | each { |p|
        let branch = git -C $p rev-parse --abbrev-ref HEAD
        $" - ($p) 󰘬 (ansi magenta)($branch)(ansi reset)"
    } | input list --index --fuzzy "Select the repo to see status:")
    show_stats ($paths | get $p)
}
