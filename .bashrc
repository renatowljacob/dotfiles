#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Aliases
alias cat='bat '
alias cs50="CC='clang' CFLAGS='-ferror-limit=1 -gdwarf-4 -ggdb3 -O0 -std=c11 \
	-Wall -Werror -Wextra -Wno-gnu-folding-constant -Wno-sign-compare \
	-Wno-unused-parameter -Wno-unused-variable -Wno-unused-but-set-variable \
	-Wshadow' LDLIBS='-lcrypt -lcs50 -lm' make "
alias du='gdu '
alias gconfig='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME '
alias grep='grep --color=auto '
alias locate='plocate '
alias ls='eza --icons=auto --hyperlink --no-quotes '
alias make="CFLAGS='-fmax-errors=1 -Werror -std=c11 -O0 -gdwarf -ggdb -Wall \
	-Wextra -Wformat-overflow -Wuse-after-free=1 -Wstrict-prototypes -Wshadow \
	-Wconversion' make "
alias nvim-debug='$HOME/Repos/git/neovim/build/bin/nvim '
alias nvim='nvim-remote '
alias rm='trash '
alias siv='nsxiv-rifle '

# Yazi
function yy()
{
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"

	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] &&
		[ "$cwd" != "$PWD" ]; then
		builtin cd "$cwd"
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
