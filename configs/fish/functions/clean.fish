
function my_help
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
end

function not_requires
    if count $argv -gt 0
        my_help
        exit 1
    end
    set -l flag $argv[1]

    if $flag = "-show" || $flag = "-s"
        sudo pacman -Qdt -q
        yay -Qdt -q
    else if $flag = "-remove" || $flag = "-r"
        sudo pacman -Rsn (pacman -Qdtq) --noconfirm
        sudo pacman -Scc --noconfirm
        yay -Rsn (yay -Qdtq) --noconfirm
        yay -Scc --noconfirm
    end
end

function cleanm
    if count $argv -gt 0
        my_help
        exit 1
    end
    set -l flag $argv[1]

    if $flag = "-p"
        sudo pacman -Rsn (pacman -Qdtq) --noconfirm
    else if $flag = "-c"
        sudo pacman -Sc --noconfirm && pacman -Scc --noconfirm
    else if $flag = "-a"
        cleanm -p && cleanm -c
    end
end

