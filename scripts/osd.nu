def _micro []: nothing -> float {
  return (wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | split row ':' | get 1 | str replace '[MUTED]' '' | str trim | into float)
}

def _sound []: nothing -> float {
  return (wpctl get-volume @DEFAULT_AUDIO_SINK@ | split row ':' | get 1 | str replace '[MUTED]' '' | str trim | into float)
}

def show_error [category: string, message: string] {
  sosd notification -m "" -t $"($category) Error" -d $message
}

def show_sound [volume: int = 0] {
  let icon = match $volume {
    0..0 => { '' }
    ..30 => { '' }
    31..50 => { '' }
    _ => { '' }
  }
  sosd slider -v $volume -m $icon
}

def show_brightness [value: int = 0] {
  let icon = match $value {
    ..20 => { '󰃞' }
    21..50 => { '󰃝' }
    51..70 => { '󰃟' }
    _ => { '󰃠' }
  }
  sosd slider -v $value -m $icon
}

# Audio control functions
export def "main audio-mute-toggle" [] {
  let current_status = (do -i { wpctl get-volume @DEFAULT_AUDIO_SINK@ } | complete)

  if $current_status.exit_code == 0 {
    let is_muted = ($current_status.stdout | str contains "MUTED")

    if $is_muted {
      let volume = ((_sound) * 100) | into int
      do -i { wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 }
      show_sound $volume
    } else {
      do -i { wpctl set-mute @DEFAULT_AUDIO_SINK@ 1 }
      show_sound 0
    }
  } else {
    show_error "Audio" "Could not get audio status"
  }
}

export def "main mic-mute-toggle" [] {
  let current_status = (do -i { wpctl get-volume @DEFAULT_AUDIO_SOURCE@ } | complete)

  if $current_status.exit_code == 0 {
    let is_muted = ($current_status.stdout | str contains "MUTED")

    if $is_muted {
      let volume = ((_micro) * 100) | into int
      do -i { wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 0 }
      sosd slider -v $volume -m ""
      # "Microphone unmuted"
    } else {
      do -i { wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 1 }
      sosd slider -v 0 -m ""
      # "Microphone muted"
    }
  } else {
    show_error "Microphone" "Could not get microphone status"
    # "Microphone status unknown"
  }
}

export def "main volume-up" [] {
  do -i { wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ }
  let volume = ((_sound) * 100) | into int
  show_sound $volume
}

export def "main volume-down" [] {
    do -i { wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- }
    let volume = ((_sound) * 100) | into int
    show_sound $volume
}

# Brightness control functions
export def "main brightness-up" [] {
  if (which brightnessctl | is-not-empty) {
    do -i { brightnessctl set 5%+ }
    let value = ((brightnessctl get | into int) * 100) / 255 | into int
    show_brightness $value
  } else {
    show_error "Brightness" "Could not adjust brightness"
  }
}

export def "main brightness-down" [] {
  if (which brightnessctl | is-not-empty) {
    do -i { brightnessctl set 5%- }
    let value = ((brightnessctl get | into int) * 100) / 255 | into int
    show_brightness $value
  } else {
    show_error "Brightness" "Could not adjust brightness"
  }
}

# Keyboard LED control functions
export def "main caps-lock" [] {
  if (which brightnessctl | is-not-empty) {
    let value = (brightnessctl -d input0::capslock get | into int) == 1
    let new_status = (if $value { "Caps Lock Enabled" } else { "Caps Lock Disabled" })
    # let icon = if $value { "󰘲" } else { "󰧇" }
    # let icon = if $value { "󰬈" } else { "󰯫" }
    let icon = if $value { "󱀍" } else { "󰀬" }
    sosd notification -m $icon -t $new_status
  } else {
    show_error "Caps Lock" "Could not get Caps Lock status"
  }
}

export def "main num-lock" [] {
  if (which brightnessctl | is-not-empty) {
    let value = (brightnessctl -d input0::numlock get | into int) == 1
    let new_status = (if $value { "Num Lock Enabled" } else { "Num Lock Disabled" })
    let icon = if $value { "󰌌" } else { "󰌐" }
    sosd notification -m $icon -t $new_status
  } else {
    show_error "Num Lock" "Could not get Num Lock status"
  }
}

# Main function to handle different key binds
def handle-key [key: string] {
    match $key {
        "XF86AudioMute" => { audio-mute-toggle }
        "XF86AudioMicMute" => { mic-mute-toggle }
        "XF86AudioRaiseVolume" => { audio-volume-up }
        "XF86AudioLowerVolume" => { audio-volume-down }
        "XF86MonBrightnessUp" => { brightness-up }
        "XF86MonBrightnessDown" => { brightness-down }
        "Caps_Lock" => { caps-lock-toggle }
        "Num_Lock" => { num-lock-toggle }
        _ => { $"Unknown key: ($key)" }
    }
}

# Export the functions for command line use
export def main [key?: string] {
    if $key != null {
        handle-key $key
    } else {
        print "Available commands:"
        print "- audio-mute-toggle"
        print "- mic-mute-toggle"
        print "- volume-up"
        print "- volume-down"
        print "- brightness-up"
        print "- brightness-down"
        print "- caps-lock"
        print "- num-lock"
        print ""
        print "Or use 'handle-key' with one of: XF86AudioMute, XF86AudioMicMute, XF86AudioRaiseVolume, XF86AudioLowerVolume, XF86MonBrightnessUp, XF86MonBrightnessDown, Caps_Lock, Num_Lock"
    }
}
