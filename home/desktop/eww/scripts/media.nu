def _status []: nothing -> string {
    return (playerctl status)
}

def "main song art" [] {
    let art = playerctl -a metadata mpris:artUrl | str replace -r 'open.spotify.com' 'i.scdn.co' | str replace -r 'file:\/\/' ''

    if ($art | str length) > 0 {
        print $art
    } else {
        # print $"($env.HOME)/.config/eww/assets/music-fallback.png"
        print "/etc/nixos/home/desktop/eww/assets/music-fallback.png"
    }
}

def "main meta title" [] {
    playerctl metadata --format '{{ title }}'
}

def "main meta artist" [] {
    playerctl metadata --format '{{ artist }}'
}

def "main meta position" [] {
    let pos = (playerctl -a position | into float)
    let dur = (playerctl -a metadata mpris:length | into float)

    # Calcular minutos y segundos actuales
    let curr_min = (($pos mod 3600) / 60) | into int | fill -a r -c '0' -w 2
    let curr_secs = ($pos mod 60) | into int | fill -a r -c '0' -w 2

    # Calcular minutos y segundos totales
    let total_min = ($dur / 1_000_000 / 60) | math round | fill -a r -c '0' -w 2
    let total_secs = ($dur / 1_000_000 mod 60) | math round | fill -a r -c '0' -w 2

    if $pos > 0 {
        print $"($curr_min):($curr_secs) / ($total_min):($total_secs)"
    } else {
        print ''
    }
}

def "main meta percent" [] {
    let pos = (playerctl -a position | into float)
    let dur = (playerctl -a metadata mpris:length | into float)

    print ((($dur / 1_000_000) / $pos) | math round)
}

def "main player" [] {
    let player = playerctl -a -l | lines | get 0 | split row '.' | get 0
    let status = _status

    if $status == "Playing" {
        print $"Now Playing - via ($player)"
    } else {
        print ""
    }
}

def main [] {
    print (_status)
}
