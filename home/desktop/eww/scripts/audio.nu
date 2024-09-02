def _micro []: nothing -> float {
    return (wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | split row ':' | get 1 | str replace '[MUTED]' '' | str trim | into float)
}

def _sound []: nothing -> float {
    return (wpctl get-volume @DEFAULT_AUDIO_SINK@ | split row ':' | get 1 | str replace '[MUTED]' '' | str trim | into float)
}

#
# Microphone
#
def "main micro" [] {
    let volume = ((_micro) * 100) | into int
    print ($volume)
}

def "main micro toggle" [] {
    wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
}

def "main micro set" [action: string = 'up'] {
    let volume = if $action == 'up' {
        "5%+"
    } else {
        "5%-"
    }
    wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SOURCE@ $volume
}

def "main micro icon" [] {
    let volume = ((_micro) * 100) | into int
    let muted = (wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | str contains 'MUTED')

    if $volume <= 5 or $muted {
        print ''
    } else {
        print ''
    }
}

#
# Sounds
#
def "main sound" [] {
    let volume = ((_sound) * 100) | into int
    print ($volume)
}

def "main sound toggle" [] {
    wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
}

def "main sound set" [action: string = 'up'] {
    let volume = if $action == 'up' {
        "5%+"
    } else {
        "5%-"
    }

    wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ $volume
}

def "main sound icon" [] {
    let volume = ((_sound) * 100) | into int
    let muted = (wpctl get-volume @DEFAULT_AUDIO_SINK@ | str contains 'MUTED')

    if $volume <= 5 or $muted {
        print ''
        return
    }

    match $volume {
        ..30 => { print '' }
        31..50 => { print '' }
        _ => { print '' }
    }
}

def main [] {}
