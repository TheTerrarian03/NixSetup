#!/run/current-system/sw/bin/bash

# simple function to get user input and return a value based on:
# - arrow keys: UP, DOWN, LEFT, & RIGHT
# - enter key:  ENTER
# - q:          QUIT
# - any other:  NONE
arrow_enter_quit_input() {
    # Read a single character
    read -rsn1 input  # -r: raw input, -s: silent, -n1: read 1 character

    # Check for escape sequence for arrow keys
    if [[ $input == $'\e' ]]; then
        read -rsn2 input  # Read the next two characters
        case $input in
            '[A')
                echo UP
                ;;
            '[B')
                echo DOWN
                ;;
            '[C')
                echo RIGHT
                ;;
            '[D')
                echo LEFT
                ;;
            *)  # Other escape sequences
                echo NONE
                ;;
        esac
    elif [[ $input == '' ]]; then
        echo ENTER
    elif [[ $input == 'q' ]]; then
        echo QUIT
    else
        echo NONE
    fi
}

# Single selection menu function
#
# Parameters:
# - Top prompt (string)
# - Bottom prompt (string)
# - options (array, up to 253 total items)
#
# Returns:
# - index in options array the user chose
function choice_menu() {
    # parameters
    local top_prompt="$1"
    local bottom_prompt="$2"
    local opts=("${@:3}")

    # local counter/boundary variables
    local sel_idx=0
    local max_idx=${#opts[@]}
    ((max_idx--))  # sub one from max for off-by-one
    local running=true

    echo "# options: $max_idx"

    # menu main loop
    while $running; do

        # print choice
        clear
        # echo "Select choice:"
        echo "$top_prompt"
        local i=0;
        for opt in "${opts[@]}"; do
            if [ $sel_idx -eq $i ]; then
                echo "  > $opt"
            else
                echo "    $opt"
            fi
            ((i++))
        done
        echo
        echo -n "$bottom_prompt"
        
        # key input and selection changing
        case `arrow_enter_quit_input` in
            UP)
                if [ "$sel_idx" -gt "0" ]; then ((sel_idx--)); fi
                ;;
            DOWN)
                if [ "$sel_idx" -lt "$max_idx" ]; then ((sel_idx++)); fi
                ;;
            ENTER)
                break
                ;;
            QUIT)
                sel_idx=-1
                break
                ;;
            *)
                ;;
        esac
    done
    
    return $sel_idx
}

# Simple function to toggle a chosen option string
#   expects string in format "[?] string..."
#   where ? is either ' ' or '*'
#   and string... is ther rest of the string
#
# Returns a string by echoing
#
# example usage:
#   word="[ ] this was OFF"
#   word=`toggle_option_string $word`
#   echo "$word"
function toggle_option_string() {
    old=$@
    # echo "$old"
    star="*"
    space=" "
    # echo `expr index "$1" "*"`
    if [ `expr index "$1" "*"` -eq 2 ]; then
        old=${old/"$star"/"$space"}
    elif [ `expr index "$1" "*"` -eq 0 ]; then
        old=${old/"$space"/"$star"}
    fi

    echo "$old"
}
