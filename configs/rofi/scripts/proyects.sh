#!/bin/bash

base_proyects=(
    ~/Repos
    ~/Projects
    ~/Projects/CSharp
    ~/Projects/Rust
    ~/Projects/Unity
)
declare -A dir_proyects
for proyect in "${base_proyects[@]}"; do
    if [ -d "$proyect" ]; then
        for dir in "$proyect"/*; do
            if [ -d "$dir" ]; then
                dir_proyects[${#dir_proyects[@]}]="$dir"
            fi
        done
    fi
done

echo "$(printf "%s\n" "${dir_proyects[@]}" | rofi -p "Select Proyect" -dmenu -i)" | xargs -I {} neovide "{}/"
