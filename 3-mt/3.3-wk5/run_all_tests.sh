
HC=${HC-36}
HI="\e[${HC}m"
OK="\e[32m"
ERR="\e[31m"
OFF="\e[0m"

oks=("ok")
errs=("lex" "syn" "sem" "err")
declare -a extensions
folder="tests"

NO_USAGE=0
while [ $# -ge 1 ]; do
    # we found an arg, the user knows what he's doing
    NO_USAGE=1

    # if we found a number, we consider it the "min" argument
    [[ "$1" =~ ^[0-9]+$ ]] && break

    arg=$1
    shift

    if [ -d $arg ]; then
        folder="$arg"
    else
        extensions+=($arg)
    fi    
done

# if no extensions are given, we use the default ones
[ ${#extensions} -eq 0 ] && extensions=("ok" "lex" "syn" "sem" "err") 

MIN="$1"
MAX="$2"
[ $# -eq 1 ] && MAX="$1"

get_highlight() {
    is_ok_name=false
    is_err_name=false
    for item in "${oks[@]}"; do [[ "$1" =~ $item* ]] && is_ok_name=true && break; done
    for item in "${errs[@]}"; do [[ "$1" =~ $item* ]] && is_err_name=true && break; done

    if [ "$is_err_name" == true ]; then
        echo "${ERR}"
    elif [ "$is_ok_name" == true ]; then
        echo "${OK}"
    else
        echo "${OFF}"
    fi
}


set -o pipefail
make \
    | awk '/arning/ {print "\033[33m" $0 "\033[39m"; next} {print}'
errcode=$?
set +o pipefail

[ $errcode -ne 0 ] && echo && echo -e "${ERR}Compilation error${OFF}, exiting" && exit $errcode

count=0
if [ ! -d $folder ]; then
    echo
    echo -e "${ERR}Error: test folder ${HI}$folder ${ERR}doesn't exist${OFF}"
else
    declare -A ext_count
    for ext in ${extensions[@]}; do
        for infile in `find "$folder" -type f -regex ".*[.]$ext.*" | sort 2>/dev/null`; do
            if [ $# -ge 1 ]; then
                num=`basename $infile`
                num=${num%%.*}
                if [[ "$num" =~ ^[0-9]+$ ]]; then
                    [ "$num" -lt $MIN ] && continue
                    [ "$num" -gt $MAX ] && continue
                fi
            fi

            fullext="${infile##*.}"
            ((ext_count["$fullext"]++))

            namehighlight=$(get_highlight "$ext")
            hashcount=15

            echo
            printf "%s ${namehighlight}%s${OFF} %s/${namehighlight}%s${OFF}\n" "$ext" "$(printf '%0.sv' $(seq $(($hashcount-1-${#ext}))))" "`dirname $infile`" "`basename $infile`"

            set -o pipefail
            ./while $infile 2>&1 \
                | awk '/error/ {print "\033[31m" $0 "\033[0m"; next} {print}' \
                | awk '/uccess/ {print "\033[32m" $0 "\033[0m"; next} {print}' \
                | awk -v on="${HC}" '{if ($0 ~ /->/) {for(i=1;i<=NF;i++) if ($i ~ /^[a-z_0-9]+$/) $i="\033[" on "m"$i"\033[0m"} print}' \
                | awk -v on="${HC}" '{gsub(/\([^)]*\)/, "\033[35m&\033[0m"); print}'

            errcode=$?
            set +o pipefail

            expectederr=0
            [ $namehighlight == "$ERR" ] && expectederr=1
            supposedto="execute successfully"
            [ $namehighlight == "$ERR" ] && supposedto="fail"
            whatitdid="executed successfully"
            [ $errcode -ne 0 ] && whatitdid="failed"
            if [ $errcode -eq $expectederr ]; then
                printf "%s ${namehighlight}%s${OFF} %s/${namehighlight}%s${OFF} executed ${OK}with the expected outcome$OFF." "$ext" "$(printf '%0.s^' $(seq $(($hashcount-1-${#ext}))))" "`dirname $infile`" "`basename $infile`"
                # echo -e "Program ${OK}$infile${OFF} (as ${namehighlight}$ext${OFF}) executed ${OK}with the expected outcome$OFF."
            else
                printf "%s ${namehighlight}%s${OFF} ${ERR}Error:${OFF} %s/${namehighlight}%s${OFF} is supposed to ${namehighlight}$supposedto$OFF but it ${namehighlight}$whatitdid$OFF!" "$ext" "$(printf '%0.s^' $(seq $(($hashcount-1-${#ext}))))" "`dirname $infile`" "`basename $infile`"
            fi

            echo

            ((count++))
        done
    done

    echo
    echo -e "Ran ${HI}$count${OFF} test cases in ${HI}$folder${OFF} with extensions ${HI}$(IFS=,; echo "${extensions[*]}")${OFF}"

    for ext in "${extensions[@]}"; do
        if [[ -n "${ext_count[$ext]}" ]]; then
            namehighlight=$(get_highlight "$ext")
            printf "  ${namehighlight}%2d${OFF} files: ${namehighlight}.$ext${OFF}\n" "${ext_count[$ext]}"
        fi
    done
fi

for ext in "${!ext_count[@]}"; do
    if [[ ! " ${extensions[@]} " =~ "$ext" ]]; then
        namehighlight=$(get_highlight "$ext")
        printf "  ${namehighlight}%2d${OFF} files: ${namehighlight}.$ext${OFF}\n" "${ext_count[$ext]}"
    fi
done

if [ $count -eq 0 -o $NO_USAGE -eq 0 ]; then
    echo
    echo -e "Usage options"
    echo -e "${HI}$0 lexical-error${OFF}   | Run tests with the given extension"
    echo -e "${HI}$0 lex${OFF}             | Abbreviate to just the prefix (e.g. ${HI}ok${OFF}, ${HI}lex${OFF}, ${HI}syn${OFF}, ${HI}sem${OFF}, ${HI}err${OFF})"
    echo -e "${HI}$0 lex ok syn${OFF}      | ... or even use several of them"
    echo -e "${HI}$0 mytests syn${OFF}     | Use tests from a custom path"
    echo -e "${HI}$0 syn mytests lex${OFF} | ... the first folder is considered as the path"
    echo -e "${HI}$0 lex 3${OFF}           | Run only a specific test"
    echo -e "${HI}$0 lex 3 4${OFF}         | ... or a range of them"
    echo -e "${HI}$0 ok mytests 3 4${OFF}  | ... combined with other options"
    echo -e "${HI}HC=33 $0${OFF}           | Use a custom highlight (${HI}31${OFF}..${HI}36${OFF})"
fi
