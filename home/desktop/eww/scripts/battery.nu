def battery [] -> string {
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
        print ''
    } else {
        let status = cat $"($bat_path)/status"
        let level = (cat $"($bat_path)/capacity" | into int)

        match [$status, $level] {
            ["Charging", $x] if $x >= 40 => { print '' },
            ["Charging", $x] => { print '#ffb29b' }, # yellow
            ["Discharging", $x] if $x <= 30 => { print '#ee6a70' }, # red
            _ => { print '' }
        }
    }
}

def "main icon" [] {
    let bat_path = battery
    if ($bat_path | str length) == 0 {
        print '󱉝'
    } else {
        let status = cat $"($bat_path)/status"
        let level = (cat $"($bat_path)/capacity" | into int)

        match [$status, $level] {
            ["Charging", $x] if $x == 100 => { print '󰂄' },
            ["Charging", $x] if $x >= 90 => { print '󰂋' },
            ["Charging", $x] if $x >= 80 => { print '󰂊' },
            ["Charging", $x] if $x >= 70 => { print '󰢞' },
            ["Charging", $x] if $x >= 60 => { print '󰂉' },
            ["Charging", $x] if $x >= 50 => { print '󰢝' },
            ["Charging", $x] if $x >= 40 => { print '󰂈' },
            ["Charging", $x] if $x >= 30 => { print '󰂇' },
            ["Charging", $x] if $x >= 20 => { print '󰂆' },
            ["Charging", $x] if $x >= 10 => { print '󰢜' },
            ["Charging", $x] => { print '󰢟' },
            ["Discharging", $x] if $x == 100 => { print '󰂃' },
            ["Discharging", $x] if $x >= 90 => { print '󰂂' },
            ["Discharging", $x] if $x >= 80 => { print '󰂁' },
            ["Discharging", $x] if $x >= 70 => { print '󰂀' },
            ["Discharging", $x] if $x >= 60 => { print '󰁿' },
            ["Discharging", $x] if $x >= 50 => { print '󰁾' },
            ["Discharging", $x] if $x >= 40 => { print '󰁽' },
            ["Discharging", $x] if $x >= 30 => { print '󰁼' },
            ["Discharging", $x] if $x >= 20 => { print '󰁻' },
            ["Discharging", $x] if $x >= 10 => { print '󰁺' },
            _ => { print '󰁹' }
        }
    }
}

def main [] {}
