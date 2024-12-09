# from zsh_unplugged
##? Clone a plugin, identify its init file, source it, and add it to your fpath.
function plugin-load {
local repo plugdir initfile initfiles=()
: ${ZPLUGINDIR:=${ZDOTDIR:-~/.config/zsh}/plugins}
for repo in $@; do
	plugdir=$ZPLUGINDIR/${repo:t}
	initfile=$plugdir/${repo:t}.plugin.zsh
	if [[ ! -d $plugdir ]]; then
		echo "Cloning $repo..."
		git clone -q --depth 1 --recursive --shallow-submodules \
			https://github.com/$repo $plugdir
	fi
	if [[ $repo == "zdharma-continuum/fast-syntax-highlighting" ]]; then
		mytheme="~/.config/zsh/theme/default.ini"
		themefile="~/.config/zsh/plugins/fast-syntax-highlighting/themes/default.ini"

		if [[ -e $mytheme && -e $themefile ]]; then
			cp $mytheme $themefile
		fi
	fi
	if [[ ! -e $initfile ]]; then
		initfiles=($plugdir/*.{plugin.zsh,zsh-theme,zsh,sh}(N))
		(( $#initfiles )) || { echo >&2 "No init file '$repo'." && continue }
		ln -sf $initfiles[1] $initfile
	fi
	fpath+=$plugdir
	(( $+functions[zsh-defer] )) && zsh-defer . $initfile || . $initfile
done
}

repos=(
	jeffreytse/zsh-vi-mode
	zdharma-continuum/fast-syntax-highlighting
	zsh-users/zsh-autosuggestions
	zsh-users/zsh-history-substring-search
)

plugin-load $repos

ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_HIGHLIGHT_HIGHLIGHTERS+=(main brackets)

autoload -U compinit; compinit

unsetopt menu_complete
setopt auto_cd
setopt always_to_end
setopt auto_param_slash
setopt auto_menu
setopt hash_list_all
setopt append_history
setopt share_history
setopt hist_ignore_space
setopt hist_expire_dups_first
setopt inc_append_history
setopt correct

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

alias cat='bat '
alias du='gdu '
alias gconfig='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME '
alias grep='grep --color=auto '
alias lf='lfrun '
alias locate='plocate '
alias ls='eza --icons=auto --hyperlink --no-quotes'
alias nvim-debug='NVIM_APPNAME="nvim-debug" nvim'
alias rm='trash '
alias siv='nsxiv-rifle '


bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

LFCD=$HOME/.config/lf/lf.bash
if [ -f "$LFCD" ]; then
	emulate ksh -c 'source $LFCD'
fi

export CC="clang"
export CFLAGS="-ferror-limit=1 -gdwarf-4 -ggdb3 -O0 -std=c11 -Wall -Werror -Wextra -Wno-gnu-folding-constant -Wno-sign-compare -Wno-unused-parameter -Wno-unused-variable -Wno-unused-but-set-variable -Wshadow"
export LDLIBS="-lcrypt -lcs50 -lm"

export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/ssh-agent.socket

function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd "$cwd"
	fi
	rm -f -- "$tmp"
}

eval "$(zoxide init --cmd cd zsh)"
eval "$(starship init zsh)"
eval "$(fzf --zsh)"
