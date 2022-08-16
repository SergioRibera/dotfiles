#!/bin/bash

#   ┌───────────────────────────────┐
#   │                               │
#   │       Colors Variables        │
#   │                               │
#   └───────────────────────────────┘

COLOR_NC='\e[0m' # No Color
COLOR_BLACK='\e[0;30m'
COLOR_GRAY='\e[1;30m'
COLOR_RED='\e[0;31m'
COLOR_LIGHT_RED='\e[1;31m'
COLOR_GREEN='\e[0;32m'
COLOR_LIGHT_GREEN='\e[1;32m'
COLOR_BROWN='\e[0;33m'
COLOR_YELLOW='\e[1;33m'
COLOR_BLUE='\e[0;34m'
COLOR_LIGHT_BLUE='\e[1;34m'
COLOR_PURPLE='\e[0;35m'
COLOR_LIGHT_PURPLE='\e[1;35m'
COLOR_CYAN='\e[0;36m'
COLOR_LIGHT_CYAN='\e[1;36m'
COLOR_LIGHT_GRAY='\e[0;37m'
COLOR_WHITE='\e[1;37m'

#   ┌───────────────────────────────┐
#   │                               │
#   │       Program Variables       │
#   │                               │
#   └───────────────────────────────┘

repoconfigdir="$PWD/configs"
userconfigdir="$HOME/.config"

# Some Packages Managers
declare -A osInfo;
osInfo[/etc/debian_version]="sudo apt-get install -y"
osInfo[/etc/alpine-release]="apk --update add"
osInfo[/etc/centos-release]="yum install -y"
osInfo[/etc/fedora-release]="dnf install -y"
osInfo[/etc/arch-release]="pacman -Sy"

pacmanPackages=(alacritty zsh neovim bspwm sxhkd polybar picom-jonaburg-git steam)
#pacmanPackages=( \
    #["alacritty"]="" \
    #["zsh"]="" \
    #["neovim"]="" \
    #["bspwm"]="" \
    #["sxhkd"]="" \
    #["polybar"]="" \
    #["picom-jonaburg-git"]="" \
    #["steam"]="" \
#)

set -e

trap banner EXIT


banner(){
    clear
    printf "${COLOR_YELLOW}"
    printf "   __   __  __   __    ______   _______  _______  _______  ___   ___      _______  _______ \n" 
    printf "  |  |_|  ||  | |  |  |      | |       ||       ||       ||   | |   |    |       ||       |\n"  
    printf "  |       ||  |_|  |  |  _    ||   _   ||_     _||    ___||   | |   |    |    ___||  _____|\n"  
    printf "  |       ||       |  | | |   ||  | |  |  |   |  |   |___ |   | |   |    |   |___ | |_____ \n"
    printf "  |       ||_     _|  | |_|   ||  |_|  |  |   |  |    ___||   | |   |___ |    ___||_____  |\n"
    printf "  | ||_|| |  |   |    |       ||       |  |   |  |   |    |   | |       ||   |___  _____| |\n"  
    printf "  |_|   |_|  |___|    |______| |_______|  |___|  |___|    |___| |_______||_______||_______|\n" 
    echo ""
    printf "${COLOR_NC}\n"
    printf "                          Made with the ${COLOR_RED}❤️${COLOR_NC} by ${COLOR_BLUE}SergioRibera${COLOR_NC}           \n"
    printf "\n\n\n"
}

end_banner(){
    banner
    echo "        Please Follow on my Social Medias:"
    printf "        ${COLOR_RED}Youtube  ${COLOR_NC}     https://www.youtube.com/channel/UCm_CD6QqAEgtaHde9UycbuA\n"
    printf "        ${COLOR_BLUE}Facebook ${COLOR_NC}     https://facebook.com/SergioRiberaID\n"
    printf "        ${COLOR_CYAN}Twitter  ${COLOR_NC}     https://twitter.com/SergioRibera_ID\n"
    printf "        ${COLOR_PURPLE}Twitch   ${COLOR_NC}     https://twitch.tv/sergioriberaid\n"
    printf "        ${COLOR_GRAY}GitHub   ${COLOR_NC}     https://github.com/SergioRibera\n"
    echo ""
    echo "        If you like, support me on:"
    printf "        ${COLOR_LIGHT_RED}Ko-fi    ${COLOR_NC}     https://ko-fi.com/sergioribera\n"
    printf "        ${COLOR_LIGHT_PURPLE}Patreon  ${COLOR_NC}     https://www.patreon.com/SergioRibera\n"
    printf "        ${COLOR_LIGHT_CYAN}Paypal Me${COLOR_NC}     https://paypal.me/SergioRibera\n"
    echo ""
}

first_menu(){
    while [[ $inputvalid == 0 ]] || [[ $inputvalid < 1 ]] || [[ $inputvalid > 4 ]]
    do
        clear
        banner
        printf "      ${COLOR_GREEN}1${COLOR_NC}) Install Only Configurations Files\n"
        printf "      ${COLOR_GREEN}2${COLOR_NC}) Install Only Applications     ${COLOR_LIGHT_RED}** Not yet available **${COLOR_NC}\n"
        printf "      ${COLOR_GREEN}3${COLOR_NC}) Install Both (Applications and Configurations Files)\n"
        printf "      ${COLOR_GREEN}4${COLOR_NC}) Exit\n"
        echo ""
        echo ""
        printf "      Type one option: ${COLOR_BLUE}"
        read -n 2 inputvalid
    done
}

second_menu(){
    case $inputvalid in
        1)
            clear
            banner
            install_config_files
            ;;
        2)
            clear
            banner
            install_apps
            ;;
        3)
            clear
            banner
            install_apps
            clear
            banner
            install_config_files
            ;;
    esac
    printf "${COLOR_NC}\n"
    read -n 1 -s -r -p "        Press any key to exit"
    printf "\n"
}

show_process(){
    printf "            [${COLOR_BLUE}*${COLOR_NC}] $1\n"
}

install_config_files(){
    mkdir -p $userconfigdir
    for f in ${repoconfigdir}/*
    do
        foldername=$(basename $f)
        show_process "Install Configs for ${COLOR_CYAN}${foldername^}${COLOR_NC}"
        #printf "            [${COLOR_BLUE}*${COLOR_NC}] Install Configs for ${COLOR_CYAN}${foldername^}${COLOR_NC}\n"
        #
        #
        #       Do cp
        #
        #
        sleep 1
    done
    printf "\n\t\t\tInstall local configs into ${COLOR_CYAN}~/${COLOR_NC}\n"
    filestocopy=(.my_commands.sh .zshrc)
    for f in ${filestocopy[@]}
    do
	filename=$(basename $f)
        show_process "Install Configs for ${COLOR_CYAN}${filename^}${COLOR_NC}"
    	cp -r $f $HOME/
	touch $f
	sleep 1
    done
    printf "\n\n"
}

install_apps(){
    printf "        Do you want to confirm each installation? y/n: "
    read -n 1 -r confirm_each
    printf "\n\n"
    #for f in ${!osInfo[@]}
    #do
    #    if [[ -f $f ]];then
    #        package_manager=${osInfo[$f]}
    #    fi
    #done
    package_manager="yay -S"
    if ! hash yay 2>/dev/null; then
        sudo pacman -S --needed git base-devel
        git clone https://aur.archlinux.org/yay.git
        cd yay && makepkg -si
    fi
    pacmanConfirmedPackages=(  )
    if [[ $confirm_each == "y" ]]; then
        for i in "${pacmanPackages[@]}";
        do
                printf "        Prepare to install ${COLOR_CYAN}${i^}${COLOR_NC}? (y/n): "
                read -n 1 -r localConfirm
                printf "\n"
                if [[ $localConfirm == "y" ]]; then
                    if [[ ${#pacmanConfirmedPackages[@]} -eq 0 ]]; then
                        pacmanConfirmedPackages+=( $i )
                    else
                        pacmanConfirmedPackages=( ${pacmanConfirmedPackages[@]} $i )
                    fi
                fi
        done
    else
        pacmanConfirmedPackages+=${pacmanPackages[@]}
    fi
    #printf "${pacmanConfirmedPackages[*]}"

    #
    #   To do Install All Packages
    #

    printf "        Install My Custom ${COLOR_CYAN}ST (Terminal)${COLOR_NC}? (y/n): "
    read -n 1 -r installST
    printf "\n"
    if [[ $installST == "y" ]]; then
        git clone https://github.com/SergioRibera/st-sr
        cd st-sr
        sudo make clean install
    fi
}

main(){
    inputvalid=0
    first_menu
    second_menu
    end_banner
    exit 0
}
main
