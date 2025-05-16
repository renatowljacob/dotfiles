if pgrep dusk >/dev/null || pgrep awesome >/dev/null; then
    exit
fi

PS3='Please enter your choice: '
list=("Dusk" "Awesome" "Shell")
select item in "${list[@]}"
do
    item=${item:-"Dusk"}
    case $item in
    "Dusk")
        startx "$XDG_CONFIG_HOME/X11/xinitrc" "dusk"
        break
        ;;
    "Awesome")
        startx "$XDG_CONFIG_HOME/X11/xinitrc" "awesome"
        break
        ;;
    "Shell") break ;;
    *) echo "invalid option $REPLY" ;;
    esac
done
