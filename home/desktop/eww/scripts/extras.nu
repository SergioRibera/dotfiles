def "main toggle" [name: string] {
    if (eww active-windows | str contains $name) {
        eww close $name
    } else {
        eww open --screen 0 $name
    }
}

def main [] {}
