#!/usr/bin/env bash

dir="$HOME/.config/rofi"
rofi_command="rofi -theme $dir/styles/screenshot.rasi"
# rofi_command="rofi"

# Error msg
msg() {
    rofi -theme "$HOME/.config/rofi/styles/message.rasi" -e "Please install 'scrot' first."
}

# Options
screen=""
allscreen=""
area=""
window=""

# Variable passed to rofi
options="$screen\n$allscreen\n$area\n$window"

chosen="$(echo -e "$options" | $rofi_command -p '' -dmenu -selected-row 1)"
case $chosen in
    $screen)
        if [[ -f /usr/bin/flameshot ]]; then
            flameshot screen -c &
        else
            msg
        fi
        ;;
    $allscreen)
        if [[ -f /usr/bin/flameshot ]]; then
            flameshot full -c &
        else
            msg
        fi
        ;;
    $area)
        if [[ -f /usr/bin/flameshot ]]; then
            sleep 1 && flameshot gui &
        else
            msg
        fi
        ;;
    $window)
        if [[ -f /usr/bin/scrot ]]; then
            sleep 1 && scrot -u 'Screenshot_%Y%m%e_%H%M%S.png' -e 'mv $f $(xdg-user-dir PICTURES)/Screenshots' &
        else
            msg
        fi
        ;;
esac

