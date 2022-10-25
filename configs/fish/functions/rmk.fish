
function _rmk_help
    echo -e "rmk command\n"
    echo -e "Author: @SergioRibera\n\n"
    echo -e "Usage:"
    echo -e "\trmk [OPTIONS...] <FILE>\n\n"
    echo -e "[Options]"
    echo -e "\t-h, --help                                 Show this message"
    echo -e "\t-i, --iteration <int> [Default: 3]         Define iterations for overwrite bites"
    echo -e "\t-j <int> [Default: 4]                      Threads to use for run more fast"
    echo -e "\n[Files]"
    echo -e "\tThe files can be are a file, files or directory"
end

function _rmk_file -S -V iteration -V f
    echo "Permanent remove \"$f\""
    scrub -p dod $f
    shred -zun $iteration $f
end

function _split_by_jobs -S
    set -l c (count $files)
    set -l nm (math --scale=0 "$c / $threads")
    for file in $files
        echo "$file"
    end | xargs -n $nm
end

function rmk
    set -l files 
    set -l iteration 3
    set -l threads 4

    set -l added
    set -l count (count $argv)

    for i in (seq $count)
        switch $argv[$i]
            case '-h'
                _rmk_help
                set i $count
            case '--help'
                _rmk_help
                set i $count
            case '-i'
                set -l x (math $i + 1)
                set iteration $argv[$x]
                set i (math $i + 2)
            case '--iteration'
                set -l x (math $i + 1)
                set iteration $argv[$x]
                set i (math $i + 2)
            case '-j'
                set -l x (math $i + 1)
                set threads $argv[$x]
                set i (math $i + 2)
            case '*'
                if test -z "$added"
                    set -l l_files $argv[(math $i + 1)..-1]
                    for file in $l_files
                        if [ -d $file ]
                            if [ (count $files) -eq 0 ]
                                set files (find $file -type f)
                            else
                                set -a files (find $file -type f)
                            end
                        else
                            set -a files $file
                        end
                    end
                    set added "true"
                    set i $count
                end
        end
    end

    echo "Files to remove: $(count $files)"
    sleep 2
    if [ (count $files) -gt 20 ]
        _split_by_jobs $threads $files |
        while read tf
            for f in (string split ' ' $tf)
                _rmk_file $iteration $f
            end &
        end
    else
        for file in $files
            _rmk_file $file $iteration
        end
    end
end
