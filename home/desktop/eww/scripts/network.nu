def "main name" [n: number = 7] {
    let name = nmcli d status | detect columns --combine-columns 3.. | where TYPE == 'wifi' | get CONNECTION | get 0

    if ($name | str length) > $n {
        print $"($name | str substring ..$n)..."
    } else {
        print $name
    }
}

def "main icon" [] {
    let data = (nmcli -f ACTIVE,SIGNAL,SSID d wifi | detect columns --combine-columns 2.. | where ACTIVE == 'yes')
    let status = (nmcli -t -f NAME c show --active | lines | get 0)

    if $status == 'lo' {
        print '󰤭'
    } else if $status == '' {
        print '󰤩'
    } else {
        let level = $data | get SIGNAL | get 0 | into int
        if $level <= 25 {
            print '󰤟'
        } else if $level <= 50 {
            print '󰤢'
        } else if $level <= 75 {
            print '󰤥'
        } else {
            print '󰤨 '
        }
    }
}

def "main status" [] {
    let status = nmcli d status | detect columns | where TYPE == 'wifi' | get STATE | get 0

    print $status
}

def main [] {}
