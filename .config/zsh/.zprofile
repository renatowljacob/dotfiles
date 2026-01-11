if pgrep dusk >/dev/null; then
    exit
fi

PS3='Please enter your choice: '
list=("dusk" "shell")
select item in "${list[@]}"
do
    item=${item:-"dusk"}
    case $item in
    "dusk")
        startx "$XDG_CONFIG_HOME/X11/xinitrc" "dusk"
        break
        ;;
    "shell") break ;;
    *) echo "invalid option $REPLY" ;;
    esac
done
