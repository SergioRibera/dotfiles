def "main name" [n: number = 7] {
    let name = nmcli d status | detect columns --combine-columns 3.. | where TYPE == 'wifi' | get CONNECTION | get 0

    if ($name | str length) > $n {
        print $"($name | str substring ..$n)..."
    } else {
        print $name
    }
}

def "main icon" [] {
    let status = nmcli d status | detect columns | where TYPE == 'wifi' | get STATE | get 0

    if $status == 'connected' {
        print '󰤨 '
    } else {
        print '󰤭 '
    }
}

def "main status" [] {
    let status = nmcli d status | detect columns | where TYPE == 'wifi' | get STATE | get 0

    print $status
}

def main [] {}
