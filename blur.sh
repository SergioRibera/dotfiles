#!/usr/bin/env sh

eval "$1 &"

i=0
while [ "$i" -lt 18 ]; do
    if [[ "$i" -lt 6 ]]; then
        sleep 0.1s
    else
        sleep 0.2s
    fi
    xdotool search -classname "$2" | xargs -I{} xprop -f _KDE_NET_WM_BLUR_BEHIND_REGION 32c -set _KDE_NET_WM_BLUR_BEHIND_REGION 0 -id {}}}""
    i=$((i + 1))
done
