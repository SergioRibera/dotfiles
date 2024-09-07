#!/bin/sh

# Configuración
SCREENKEY_LIMIT=${SCREENKEY_LIMIT:-3}
INACTIVITY_TIMEOUT=${INACTIVITY_TIMEOUT:-5}
REMOTE_CLOSE_FILE="/tmp/close_keyboard_events"

# Inicializar variables
declare -a keyboard_events
mouse_events=""
last_input_time=$(date +%s)

map_keycode() {
    case "$1" in
        enter) echo "󰌑" ;;
        space) echo "󱁐" ;;
        backspace) echo "󰌍" ;;
        tab) echo "" ;;
        esc) echo "󱊷" ;;
        up) echo "" ;;
        down) echo "" ;;
        left) echo "" ;;
        right) echo "" ;;
        minus) echo "-" ;;
        equals) echo "" ;;
        leftbrace) echo "{" ;;
        rightbrace) echo "}" ;;
        backslash) echo "\\" ;;
        apostrophe) echo "'" ;;
        grave) echo "\`" ;;
        comma) echo "," ;;
        dot) echo "." ;;
        slash) echo "/" ;;
        semicolon) echo ";" ;;
        kp*) echo $(echo "$1" | sed 's/kp//g') ;;
        *ctrl) echo "ctrl" ;;
        *shift) echo "󰘶" ;;
        *alt) echo "alt" ;;
        *meta) echo " " ;;
        *) echo "$key" ;;
    esac
}

update_keyboard_events() {
    local key="$1"
    local press="$2"
    local updated=false

    for i in "${!keyboard_events[@]}"; do
        IFS=':' read -r existing_key existing_press <<< "${keyboard_events[$i]}"
        if [ "$existing_key" = "$key" ]; then
            keyboard_events[$i]="$key:$press"
            updated=true
            break
        fi
    done

    if [ "$updated" = false ]; then
        if [ ${#keyboard_events[@]} -ge $SCREENKEY_LIMIT ]; then
            keyboard_events=("${keyboard_events[@]:1}")
        fi
        keyboard_events+=("$key:$press")
    fi
}

generate_eww_kbd_component() {
    local keyboard_component="(box :spacing 10 :orientation 'h' :vexpand true :valign 'center' :space-evenly false"
    for event in "${keyboard_events[@]}"; do
        IFS=':' read -r key press <<< "$event"
        if [ "$press" = "true" ]; then
            keyboard_component="$keyboard_component (key :l true :v '$key')"
        else
            keyboard_component="$keyboard_component (key :v '$key')"
        fi
    done

    echo "$keyboard_component)"
}

generate_eww_mouse() {
    IFS=':' read -r ev press <<< "$mouse_events"
    if [ -n "$ev" ]; then
        eww update "mouse_$ev=$press"
        mouse_events=""
    fi
}

check_inactivity() {
    local current_time=$(date +%s)
    local time_diff=$((current_time - last_input_time))

    if [ $time_diff -ge $INACTIVITY_TIMEOUT ] && [ ${#keyboard_events[@]} -gt 0 ]; then
        keyboard_events=("${keyboard_events[@]:1}")
        mouse_events=""
        eww_update
        last_input_time=$current_time
    fi
}

eww_update() {
    eww_component=$(generate_eww_kbd_component)
    generate_eww_mouse
    eww update keys="$eww_component"
}

process_event() {
    local type="$1"
    local key="$2"
    local value="$3"

    case "$type" in
        key)
            mapped_key=$(map_keycode "$key")
            if [ "$value" = "1" ]; then
                update_keyboard_events "$mapped_key" "true"
            elif [ "$value" = "0" ]; then
                update_keyboard_events "$mapped_key" "false"
            fi
            ;;
        btn)
            pressed=$([ "$value" = "1" ] && echo '#EF8891' || echo '#282c34')
            mouse_events=("$key:$pressed")
            ;;
        rel)
            if [ "$key" = "wheel" ]; then
                mouse_events="wheel:$value"
            else
                echo "restore wheel"
                mouse_events="wheel:0"
            fi
            ;;
    esac

    eww_update
    last_input_time=$(date +%s)
}

# Eliminar el archivo de cierre si existe
rm -f "$REMOTE_CLOSE_FILE"

# Iniciar el bucle principal
evsieve --input /dev/input/event0 --input /dev/input/event1 --input /dev/input/event2 --input /dev/input/event5 --block msc --block abs --block rel:x --block rel:y --print format=direct | while IFS=':' read -r type key value device; do
    # Verificar si se debe cerrar el script
    if [ -e "$REMOTE_CLOSE_FILE" ]; then
        echo "Cerrando el script por solicitud remota."
        rm -f "$REMOTE_CLOSE_FILE"
        exit 0
    fi

    check_inactivity
    process_event "$type" "$key" "${value%%@*}"
done &

# Bucle para verificar inactividad y cierre remoto
while true; do
    if [ -e "$REMOTE_CLOSE_FILE" ]; then
        echo "Cerrando el script por solicitud remota."
        rm -f "$REMOTE_CLOSE_FILE"
        kill $(jobs -p)
        exit 0
    fi
    check_inactivity
    sleep 1
done
