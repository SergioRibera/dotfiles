#!/bin/bash

function my-help(){
    echo ''
    echo 'not-requires:'
    echo ''
    echo '      -show , -s                  Use this command to show the packages that are not being used'
    echo '      -remove , -r                Use this command to remove packages that are not being used'
    echo ''
    echo 'cleanm:'
    echo ''
    echo '	-p			    This command clean pacman residue'
    echo '	-c			    This command clean Cache trash'
    echo '	-a			    This command clean all residue on before remove package'
    echo ''
    echo ''
    echo 'This tool has been created whit <3 for SergioRibera'
    echo ''
}
function not-requires(){
    if [[ $1 = "-show" || $1 = "-s" ]]
    then
        sudo pacman -Qdt -q
	yay -Qdt -q
    elif [[ $1 = "-remove" || $1 = "-r" ]]
    then
        sudo pacman -Rsn $(pacman -Qdtq) --noconfirm
	sudo pacman -Scc --noconfirm
	yay -Rsn $(yay -Qdtq) --noconfirm
	yay -Scc --noconfirm
    else
        my-help
    fi
}
function cleanm(){
    if [[ $1 = "-p" ]]
    then
	sudo pacman -Rsn $(pacman -Qdtq) --noconfirm
    elif [[ $1 = "-c" ]]
    then
	sudo pacman -Sc --noconfirm && pacman -Scc --noconfirm
    elif [[ $1 = "-a" ]]
    then
	cleanm -p && cleanm -c
    else
	my-help
    fi
}
