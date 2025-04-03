#!/run/current-system/sw/bin/bash

. ./util.sh

# repo manager
function repo_manager {
    while true; do
        clear
        echo "----> Git Repo Manager <----"
        echo
        echo "> PWD: $PWD"
        echo
        echo "Choose an option:"
        echo "s. show status -- \`git status\`"
        echo "d. show diff between head and main -- \`git diff HEAD\`"
        echo "f. fetch and pull -- \`git fetch && git pull\`"
        echo "a. add all changes -- \`git add .; git status\`"
        echo "c. commit changes -- \`git commit -m \$MSG\`"
        echo "p. push changes -- \`git push\`"
        echo "q. exit git manager"
        echo -n "> "

        read -n1 git_choice

        echo

        case $git_choice in
            s)
                git status
                ;;
            d)
                git diff HEAD
                ;;
            f)
                git fetch && git pull
                ;;
            a)
                git add .
                git status
                ;;
            c)
                echo "Please enter what you want your commit message to be:"
                echo -n "> "

                read comm_msg

                git commit -m "$comm_msg"
                ;;
            p)
                git push
                ;;
            q)
                break
                ;;
            *)
                echo "Invalid option!"
                ;;
        esac

        if ! [[ $git_choice == "q" ]]; then
            _pause
        fi
    done
}

# config manager
function config_manager {
    # main loop - menu

        # ask for choice:
                # compare
            # compare current config to stored preset
            # compare stored preset to current config
                # overwrite/save
            # overwrite stored preset with current config
            # overwrite current config with stored preset
                # update and manage
            # rebuild nixos
            # collect garbage
            # nixos-


    # define array of presets

    # read from presets.csv into array

    # print 
    echo "not implemented"
}

# profile manager
function profile_manager {
    echo "not implemented"
}

# pause func
function _pause {
    read -p "Press enter to continue..."
}

# ----- MAIN CODE -----

# change working directory if it was passed in
if [ -z "$1" ]; then
    echo "New path not passed in, working in $PWD"
else
    cd "$1" || { echo "Failed to change directory from $PWD to $1"; exit 1; }
    echo "Working in $PWD"
fi

# main loop
while true; do
    clear
    echo "===== Nix Manager ====="
    echo
    echo "> PWD: $PWD"
    echo
    echo "Choose an option:"
    echo "1. Manage this git repo"
    echo "2. Manage system configuration files"
    echo "3. Manage system profiles"
    echo "4. exit"
    echo -n "> "

    read -n1 choice

    echo

    case $choice in
        1)
            repo_manager
            # _pause
            ;;
        2)
            config_manager
            _pause
            ;;
        3)
            echo "Current directory: $PWD"
            echo "Files:"
            ls -la
            _pause
            ;;
        4)
            echo "Exiting..."
            break
            ;;
        *)
            echo "Invalid option!"
            ;;
    esac
done
