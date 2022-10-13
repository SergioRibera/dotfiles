#!/bin/bash

# run all desktop files on autostart
for desktop in ~/.config/autostart/*.desktop; do
    if [ -f "$desktop" ]; then
        exo-open $desktop
    fi
done
