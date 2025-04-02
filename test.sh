#!/run/current-system/sw/bin/bash

# include utils file for key input and menu functions
. ./util.sh

options=("[ ] option 1"
         "[*] option 2"
         "[*] REQUIRED")

for ((i = 0; i < 4; ++i)); do
    choice_menu "Select choice: " "[up/down]: " "${options[@]}"
    value=$?
    # echo "Chose value: $value"

    # echo "old: ${options[$value]}"
    options[$value]=`toggle_option_string "${options[$value]}"`
    # echo "new: ${options[$value]}"
done

# $options[value]=toggle_option_string $options[value]

# declare -p options