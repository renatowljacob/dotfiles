pgrep dusk >/dev/null

if [ $? -ne 0 ]; then
    PS3='Please enter your choice: '
    list=("Dusk" "Shell")
    select item in "${list[@]}"
    do
        case $item in
        "Dusk")
            startx "$XDG_CONFIG_HOME/X11/xinitrc"
            break
            ;;
        "Shell")
            break
            ;;
        *) echo "invalid option $REPLY";;
        esac
    done
fi
