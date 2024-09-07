def "main toggle" [name: string] {
    if (eww active-windows | str contains $name) {
        eww close $name
    } else {
        eww open --screen 0 $name
    }
}

def "main toggle screenkey" [] {
    if (eww active-windows | str contains screenkey) {
        eww close screenkey
        touch /tmp/close_keyboard_events
        pkill listeninput.sh
    } else {
        sh -c "~/.config/eww/scripts/listeninput.sh &"
        eww open --screen 0 screenkey
    }
}

def main [] {}
