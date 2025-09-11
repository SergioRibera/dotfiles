source ./prompt.nu

# Set the prompt to use the custom function
$env.PROMPT_COMMAND = {|| prompt }
$env.PROMPT_COMMAND_RIGHT = ""

# The prompt indicators are environmental variables that represent
# the state of the prompt
$env.PROMPT_INDICATOR = {|| prompt_status "" }
$env.PROMPT_INDICATOR_VI_INSERT = {|| prompt_status "vi" }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| prompt_status "vn" }
$env.PROMPT_MULTILINE_INDICATOR = {|| prompt_status "ml" }

$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'

if "HOME" in $env {
  $env.GITSTATUS_IGNORE_PATH = $"($env.HOME)/Contributions/nixpkgs"
}

do --env {
    let ssh_agent_file = $"/tmp/ssh-agent-($env.USER? | default $env.USER).nuon"

    if ($ssh_agent_file | path exists) {
        let ssh_agent_env = open ($ssh_agent_file)
        if ($"/proc/($ssh_agent_env.SSH_AGENT_PID)" | path exists) {
            load-env $ssh_agent_env
            return
        } else {
            rm $ssh_agent_file
        }
    }

    let ssh_agent_env = ^ssh-agent -c
        | lines
        | first 2
        | parse "setenv {name} {value};"
        | transpose --header-row
        | into record
    load-env $ssh_agent_env
    $ssh_agent_env | save --force $ssh_agent_file
}
