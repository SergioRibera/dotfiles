
function rmk
    command scrub -p dod $argv
    command shred -zun 10 -v $argv
end
