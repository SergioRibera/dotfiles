#!/bin/bash

SourceFile=$1
Extension=$2

if [[ -f $SourceFile ]];then
    ffmpeg -i "$SourceFile" -codec copy "$SourceFile.mp4" 2>&1 | zenity --width 500 --title "Video Convertor" --text "Please wait while your video file gets converted" --progress --pulsate --auto-close
    if [[ $? -ne 0 ]]; then
        zenity --info --text "Your video file couldnt be converted!"
    else
        zenity --info --text "Your video file has been converted."
    fi
else
    zenity --info --text "The file selected is invalid"
fi
