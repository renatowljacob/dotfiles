#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Aliases
which bat > /dev/null 2>&1 \
    && alias cat='bat '
which gdu > /dev/null 2>&1 \
    && alias du='gdu '
alias gcc-sanitizer='gcc -std=c11 -Wall -Wextra -Wformat-overflow \
    -Wuse-after-free=1 -Wstrict-prototypes -Wshadow -Wconversion \
    -Wno-override-init -Werror -fmax-errors=1 -fsanitize=address,undefined -O0 \
    -g3'
alias gcc-analyzer='gcc -std=c11 -Wall -Wextra -Wformat-overflow \
    -Wuse-after-free=1 -Wstrict-prototypes -Wshadow -Wconversion \
    -Wno-override-init -Werror -fmax-errors=1 -fanalyzer -O0 -g3'
alias grep='grep --color=auto '
alias gconfig='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME '
alias grep='grep --color=auto '
alias locate='plocate '
which eza > /dev/null 2>&1 \
    && alias ls='eza --icons=auto --hyperlink --no-quotes '
which trash > /dev/null 2>&1 \
    && alias rm='trash '
alias siv='nsxiv-rifle '

# Neovim aliases
alias firenvim='NVIM_APPNAME=firenvim nvim'
alias nvim-debug='$HOME/Repos/git/neovim/build/bin/nvim '
alias nvim='nvim-remote '

# Yazi
function yy()
{
    local tmp
    local cwd

    tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"

    if cwd="$(command cat -- "$tmp")" \
        && [ -n "$cwd" ] \
        && [ "$cwd" != "$PWD" ]; then
        builtin cd "$cwd" || exit
    fi

    rm -f -- "$tmp"
}

# Man
export MANWIDTH=80
if [ "$TERM" != "linux" ]; then
    export MANROFFOPT=-P-i
fi

export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/ssh-agent.socket

PS1='[\u@\h \W]\$ '

eval "$(starship init bash)"
