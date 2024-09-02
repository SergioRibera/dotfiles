def battery []: nothing -> string {
    if ('/sys/class/power_supply/BAT0' | path exists) {
        return '/sys/class/power_supply/BAT0'
    } else if ('/sys/class/power_supply/BAT' | path exists) {
        return '/sys/class/power_supply/BAT'
    } else {
        return ''
    }
}
def "main get" [] {
    let bat_path = battery
    if ($bat_path | str length) == 0 {
        print ''
    } else {
        print (cat $"($bat_path)/capacity")
    }
}

def "main exists" [] {
    print ((battery | str length) == 0)
}

def "main color" [] {
    let bat_path = battery
    if ($bat_path | str length) == 0 {
        print '#C5C8C9'
    } else {
        let status = cat $"($bat_path)/status"
        let level = (cat $"($bat_path)/capacity" | into int)

        match [$status, $level] {
            ["Charging", $x] if $x >= 40 => { print '' },
            ["Charging", $x] => { print '#ffb29b' }, # yellow
            ["Discharging", $x] if $x <= 30 => { print '#ee6a70' }, # red
            _ => { print '#C5C8C9' }
        }
    }
}

def "main icon" [] {
    let bat_path = battery
    if ($bat_path | str length) == 0 {
        print '󱉝'
    } else {
        let status = cat $"($bat_path)/status"
        let level = ((cat $"($bat_path)/capacity" | into int) / 10) | into int
        let charging = ['󰂄', '󰂋', '󰂊', '󰢞', '󰂉', '󰢝', '󰂈', '󰂇', '󰂆', '󰢜', '󰢟']
        let discharging = [ '󰁹', '󰂂', '󰂁', '󰂀', '󰁿', '󰁾', '󰁽', '󰁼', '󰁻', '󰁺', '󰂃']

        if $status == "Charging" {
            print ($charging | reverse | get $level)
        } else {
            print ($discharging | reverse | get $level)
        }
    }
}

def main [] {}
