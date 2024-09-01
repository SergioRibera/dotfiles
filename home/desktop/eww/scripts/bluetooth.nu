def _has []: nothing -> bool {
    return ((rfkill | detect columns | where TYPE == 'bluetooth' | length) > 0)
}

def _powered []: nothing -> bool {
    let status = bluetoothctl show
    return ($status | str contains "PowerState: on")
}

def _connected [n: number = 10]: nothing -> string {
    let name = (bluetoothctl devices Connected | split row " " | skip 2 | str join " " | str trim)
    if ($name | str length) > $n {
        return $"($name | str substring ..$n)..."
    } else {
        return $name
    }
}

def "main has" [] {
    print (_has)
}

def "main powered" [] {
    print (_powered)
}

def "main device" [] {
    let connected = _connected
    if ($connected | str length) > 0 {
        print ($connected)
    } else {
        print 'Bluetooth'
    }
}

def "main connected" [] {
    print ((_connected | str length) > 0)
}

def "main toggle" [] {
    let powered = _powered
    if $powered == false {
        bluetoothctl power on
        bluetoothctl pairable on
        bluetoothctl discoverable on
    } else {
        bluetoothctl power off
    }
}

def "main icon" [] {
    let has = _has
    if $has == false {
        print '󱃓'
        return
    }

    let connected = _connected
    let powered = _powered
    if (($connected | str length) > 0) or $powered == true {
        print '󰂯'
        return
    }

    print '󰂲'
}

def main [] { }
