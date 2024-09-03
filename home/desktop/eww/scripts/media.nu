def _status []: nothing -> string {
    return (playerctl -a status)
}

def "main song art" [] {
    let art = playerctl -a metadata mpris:artUrl | str replace -r 'open.spotify.com' 'i.scdn.co' | str replace -r 'file:\/\/' ''

    if ($art | str length) > 0 {
        print $art
    } else {
        print $"($env.HOME)/.config/eww/assets/music-fallback.png"
    }
}

def "main meta title" [] {
    playerctl metadata --format '{{ title }}'
}

def "main meta artist" [] {
    playerctl metadata --format '{{ artist }}'
}

def "main meta position" [] {
    let pos = (playerctl -a -s position --format "{{ duration(position) }}" | lines | get 0)
    let dur = (playerctl -a -s metadata --format "{{ duration(mpris:length) }}" | lines | get 0)

    if ($dur | str length) == 0 {
        print ''
    } else {
        print $"($pos) / ($dur)"
    }
}

def "main meta percent" [] {
    let pos = (playerctl -a -s position | into string)
    let dur = (playerctl -a -s metadata mpris:length | into float)

    if ($pos | str length) == 0 {
        print ''
        return
    }

    let pos = ($pos | str replace '.' '' | into float)

    print (($pos / $dur) * 100)
}

def "main player" [] {
    let player = playerctl -a -l | lines | get 0 | split row '.' | get 0
    let status = _status

    if ($status | str contains "Playing") {
        print $"Now Playing - via ($player)"
    } else {
        print ""
    }
}

def main [] {
    print (_status)
}
