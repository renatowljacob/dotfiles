# PLUGIN MANAGER (zsh_unplugged)
##? Clone a plugin, identify its init file, source it, and add it to your fpath.
function plugin-load
{
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
			mytheme="$HOME/.config/zsh/theme/tokyonight.ini"
			themefile="$plugdir/themes/default.ini"

			rm $themefile && ln -s $mytheme $themefile
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
	kazhala/dotbare
	zdharma-continuum/fast-syntax-highlighting
	zsh-users/zsh-autosuggestions
	zsh-users/zsh-history-substring-search
)

plugin-load $repos

# CONFIG

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
alias make="CFLAGS='-fsanitize=undefined,address -fmax-errors=1 -Werror \
	-std=c11 -O0 -gdwarf -ggdb -Wall -Wextra -Wformat-overflow \
	-Wuse-after-free=1 -Wstrict-prototypes -Wshadow -Wconversion' make "
alias nvim-debug='$HOME/Repos/git/neovim/build/bin/nvim '
alias nvim='nvim-remote '
alias rm='trash '
alias siv='nsxiv-rifle '

# Autosuggestions
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# Completion
autoload -U compinit && compinit

# Options
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

# Styling
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Dotbare
export DOTBARE_DIR="$HOME/.dotfiles"
export DOTBARE_TREE="$HOME"

_dotbare_completion_cmd

# Keybindings
# Prevent typos (for some reason <S-Space> is bound to delete the entire line)
bindkey -s "^[[32;2u" " "

# Functions

# Some keybindings bugs the prompt so they must be reseted afterwards (using
# zle reset-prompt)
function _fzf-man-widget()
{
	local manpage="echo {} \
		| sed 's/\([[:alnum:][:punct:]]*\) (\([[:alnum:]]*\)).*/\2 \1/'"
	local batman="${manpage} \
		| xargs -r man \
		| col -bx \
		| bat --language=man --plain --color always"

	man -k . \
		| sort \
		| awk -v blue=$(tput setaf 4) -v cyan=$(tput setaf 6) \
		-v res=$(tput sgr0) -v bld=$(tput bold) \
			'{ $1=blue bld $1; $2=res cyan $2; $3=res $3; } 1' \
		| fzf \
		-q "$1" \
		--ansi \
		--tiebreak=begin \
		--prompt=' Man > '  \
		--preview-window '50%,rounded,<70(up,85%,border-bottom)' \
		--preview "${batman}" \
		--bind "enter:execute(${manpage} | xargs -r man)" \
}
function _git_add()
{
	if ! dotbare --git fadd; then
		zle reset-prompt
	fi
}
function _git_files()
{
	if ! dotbare --git fedit; then
		zle reset-prompt
	fi
}
function _git_grep()
{
	if ! dotbare --git fgrep; then
		zle reset-prompt
	fi
}
function _git_log()
{
	if ! dotbare --git flog; then
		zle reset-prompt
	fi
}
function _git_stash()
{
	if ! dotbare --git fstash; then
		zle reset-prompt
	fi
}
function _git_status()
{
	if ! dotbare --git fstat; then
		zle reset-prompt
	fi
}
function _pacman_sync()
{
	local packages="$(pacman -Slq \
		| fzf --multi --preview 'cat <(pacman -Si {1}) <(pacman -Fl {1} \
		| awk "{print \$2}")')"

	[ -n "${packages}" ] && doas pacman -S -- "${packages}"
}
function _pacman_query()
{
	local packages="$(pacman -Qq \
		| fzf --multi --preview 'pacman -Qi {1}')"

	[ -n "${packages}" ] && doas pacman -Rsun -- "${packages}"
}
function _pacman_aur()
{
	local packages="$(paru -Slq | fzf --multi --preview 'paru -Si {1}')"

	[ -n "${packages}" ] && paru -S -- "${packages}"
}
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
function _zoxide_cdi()
{
	__zoxide_zi
	zle reset-prompt
}

# ZVM keybindings. ' ' at the start of some of them is meant to simulate a
# leader key
function zvm_after_lazy_keybindings()
{
	zvm_define_widget _fzf-man-widget
	zvm_define_widget _git_add
	zvm_define_widget _git_files
	zvm_define_widget _git_grep
	zvm_define_widget _git_log
	zvm_define_widget _git_stash
	zvm_define_widget _git_status
	zvm_define_widget _pacman_aur
	zvm_define_widget _pacman_sync
	zvm_define_widget _pacman_query
	zvm_define_widget _widget_dotbare_fadd
	zvm_define_widget _widget_dotbare_fedit
	zvm_define_widget _widget_dotbare_fgrep
	zvm_define_widget _widget_dotbare_flog
	zvm_define_widget _widget_dotbare_fstas
	zvm_define_widget _widget_dotbare_fstat
	zvm_define_widget _zoxide_cdi

	zvm_bindkey vicmd ' pa' _pacman_aur # Search AUR packages
	zvm_bindkey vicmd ' ps' _pacman_sync # Search Arch packages
	zvm_bindkey vicmd ' pq' _pacman_query # Search local packages
	zvm_bindkey vicmd ' sf' fzf-file-widget # Search files
	zvm_bindkey vicmd ' sh' fzf-history-widget # Search history
	zvm_bindkey vicmd ' sd' fzf-cd-widget # Search directories
	zvm_bindkey vicmd ' sm' _fzf-man-widget # Search man pages
	zvm_bindkey vicmd ' ss' _zoxide_cdi # Search zoxide directories
	zvm_bindkey vicmd ' fa' _widget_dotbare_fadd
	zvm_bindkey vicmd ' ff' _widget_dotbare_fedit
	zvm_bindkey vicmd ' fg' _widget_dotbare_fgrep
	zvm_bindkey vicmd ' fl' _widget_dotbare_flog
	zvm_bindkey vicmd ' fS' _widget_dotbare_fstash
	zvm_bindkey vicmd ' fs' _widget_dotbare_fstat
	zvm_bindkey vicmd ' ga' _git_add
	zvm_bindkey vicmd ' gf' _git_files
	zvm_bindkey vicmd ' gg' _git_grep
	zvm_bindkey vicmd ' gl' _git_log
	zvm_bindkey vicmd ' gS' _git_stash
	zvm_bindkey vicmd ' gs' _git_status
	zvm_bindkey vicmd 'k' history-substring-search-up
	zvm_bindkey vicmd 'j' history-substring-search-down
}

# Visual selection highlighting
ZVM_VI_HIGHLIGHT_BACKGROUND=#2E3C64
ZVM_VI_HIGHLIGHT_FOREGROUND=white

# Man
export MANWIDTH=80
if [ $TERM != "linux" ]; then
	export MANROFFOPT=-P-i
fi

export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/ssh-agent.socket

eval "$(zoxide init --cmd cd zsh)"
eval "$(starship init zsh)"
eval "$(fzf --zsh)"
