complete -c tldr -n "__fish_use_subcommand" -s f -l render -d 'Render a specific markdown file' -r
complete -c tldr -n "__fish_use_subcommand" -s p -l platform -d 'Override the operating system' -r -f -a "{linux	,macos	,windows	,sunos	,osx	,android	}"
complete -c tldr -n "__fish_use_subcommand" -s L -l language -d 'Override the language' -r
complete -c tldr -n "__fish_use_subcommand" -l color -d 'Control whether to use color' -r -f -a "{always	,auto	,never	}"
complete -c tldr -n "__fish_use_subcommand" -s h -l help -d 'Print help information'
complete -c tldr -n "__fish_use_subcommand" -s l -l list -d 'List all commands in the cache'
complete -c tldr -n "__fish_use_subcommand" -s u -l update -d 'Update the local cache'
complete -c tldr -n "__fish_use_subcommand" -l no-auto-update -d 'If auto update is configured, disable it for this run'
complete -c tldr -n "__fish_use_subcommand" -s c -l clear-cache -d 'Clear the local cache'
complete -c tldr -n "__fish_use_subcommand" -l pager -d 'Use a pager to page output'
complete -c tldr -n "__fish_use_subcommand" -s r -l raw -d 'Display the raw markdown instead of rendering it'
complete -c tldr -n "__fish_use_subcommand" -s q -l quiet -d 'Suppress informational messages'
complete -c tldr -n "__fish_use_subcommand" -l show-paths -d 'Show file and directory paths used by tealdeer'
complete -c tldr -n "__fish_use_subcommand" -l seed-config -d 'Create a basic config'
complete -c tldr -n "__fish_use_subcommand" -s v -l version -d 'Print the version'
complete -c tldr -n "__fish_use_subcommand" -f -a "completion"
complete -c tldr -n "__fish_use_subcommand" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c tldr -n "__fish_seen_subcommand_from completion" -s s -l shell -r -f -a "{bash	,zsh	,fish	,power-shell	,elvish	}"
complete -c tldr -n "__fish_seen_subcommand_from completion" -s h -l help -d 'Print help information'
