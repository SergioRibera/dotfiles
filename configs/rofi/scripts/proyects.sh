
dir_proyects=(
    ~/.config/nvim \
    ~/.config/rofi \
    ~/.config/bspwm \
    ~/.config/picom/picom.conf \
    ~/.config/sxhkd/sxhkdrc \
    ~/.config/dunst/dunstrc \
    ~/.config/eww \
    ~/.config/pier/pier.conf \
    ~/.config/i3 \
    ~/Proyectos/Ayudas/* \
    ~/Proyectos/C++/* \
    ~/Proyectos/C-Sharp/* \
    ~/Proyectos/C-Sharp/Clases/* \
    ~/Proyectos/NodeJs/* \
    ~/Proyectos/OperativeSystem/Extras/* \
    ~/Proyectos/OperativeSystem/* \
    ~/Proyectos/Plugins/Vim/* \
    ~/Proyectos/Python/* \
    ~/Proyectos/React/Desktop/* \
    ~/Proyectos/React/Native/* \
    ~/Proyectos/React/Web/* \
    ~/Proyectos/React/Works/* \
    ~/Proyectos/Rust/MSLearn/* \
    ~/Proyectos/Rust/neovide \
    ~/Proyectos/Rust/Desktop/* \
    ~/Proyectos/Rust/Games/* \
    ~/Proyectos/Rust/Tests/* \
    ~/Proyectos/Unity/* \
    ~/Proyectos/Unity/Jams/* \
    ~/Proyectos/Unity/Tests/* \
    ~/Proyectos/Unity/Works/* \
    ~/Proyectos/Web/* \
    ~/Proyectos/Web/GitHub/* \
    ~/Proyectos/Web/Works/* \
    ~/Proyectos/Web/Works/FernandoArrieta/* \
    ~/Proyectos/Web/Works/FernandoArrieta/LandPages \
)
cd "$(printf "%s\n" "${dir_proyects[@]}" | rofi -p "Select Proyect" -dmenu -i)" && neovide .
