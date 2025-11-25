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

			rm $themefile > /dev/null 2>&1 && ln -s $mytheme $themefile
		fi
		if [[ ! -e $initfile ]]; then
			initfiles=($plugdir/*.{plugin.zsh,zsh-theme,zsh,sh}(N))
			(( $#initfiles )) || { echo >&2 "No init file '$repo'." \
				&& continue }
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
which bat > /dev/null 2>&1 \
	&& alias cat='bat '
which gdu > /dev/null 2>&1 \
	&& alias du='gdu '
alias gconfig='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME '
alias gcc-sanitizer='gcc -std=c11 -Wall -Wextra -Wformat-overflow \
	-Wuse-after-free=1 -Wstrict-prototypes -Wshadow -Wconversion \
	-Wno-override-init -Werror -fmax-errors=1 -fsanitize=address,undefined -O0 \
	-g3'
alias gcc-analyzer='gcc -std=c11 -Wall -Wextra -Wformat-overflow \
	-Wuse-after-free=1 -Wstrict-prototypes -Wshadow -Wconversion \
	-Wno-override-init -Werror -fmax-errors=1 -fanalyzer -O0 -g3'
alias grep='grep --color=auto '
which eza > /dev/null 2>&1 \
	&& alias ls='eza --icons=auto --hyperlink --no-quotes '
which trash > /dev/null 2>&1 \
	&& alias rm='trash '
alias siv='nsxiv-rifle '

# Neovim aliases
alias firenvim='NVIM_APPNAME=firenvim nvim'
alias nvim-git="NVIM_APPNAME=nvim-git ${HOME}/Repos/git/neovim/build/bin/nvim "
alias nvim='nvim-remote '

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
export DOTBARE_DIR="${HOME}/.dotfiles"
export DOTBARE_TREE="${HOME}"

_dotbare_completion_cmd

# Keybindings
# Prevent typos (these escape sequences delete the entire line otherwise)
bindkey -s "^[[32;2u" " " # <S-Space>
bindkey -s "^[[13;2u" "\r" # <S-CR>
bindkey -s "^[[13;5u" "\r" # <C-CR>

# Functions

 # Jump through prompts
 precmd()
 {
	 print -Pn "\033]133;A\007"
 }

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
		--preview-window '50%,rounded,<70(up,75%,border-bottom)' \
		--preview "${batman}" \
		--bind "enter:execute(${manpage} | xargs -r man)" \
	}

function _git_reset_prompt_after_cmd()
{
	if ! dotbare --git ${@}; then
		zle reset-prompt
	fi
}
function _git_add()    { _git_reset_prompt_after_cmd fadd   }
function _git_files()  { _git_reset_prompt_after_cmd fedit  }
function _git_grep()   { _git_reset_prompt_after_cmd fgrep  }
function _git_log()    { _git_reset_prompt_after_cmd flog   }
function _git_stash()  { _git_reset_prompt_after_cmd fstash }
function _git_status() { _git_reset_prompt_after_cmd fstat  }

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
	local tmp
	local cwd

	tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"

	if cwd="$(command cat -- "$tmp")" \
		&& [ -n "$cwd" ] \
		&& [ "$cwd" != "$PWD" ]; then
	builtin cd "$cwd"
	fi

	rm -f -- "$tmp"
}
function _zoxide_cdi()
{
	__zoxide_zi
	zle reset-prompt
}

# ZVM keybindings
leader=' ' # leader key

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

	zvm_bindkey vicmd "${leader}pa" _pacman_aur # Search AUR packages
	zvm_bindkey vicmd "${leader}ps" _pacman_sync # Search Arch packages
	zvm_bindkey vicmd "${leader}pq" _pacman_query # Search local packages
	zvm_bindkey vicmd "${leader}sf" fzf-file-widget # Search files
	zvm_bindkey vicmd "${leader}sh" fzf-history-widget # Search history
	zvm_bindkey vicmd "${leader}sd" fzf-cd-widget # Search directories
	zvm_bindkey vicmd "${leader}sm" _fzf-man-widget # Search man pages
	zvm_bindkey vicmd "${leader}ss" _zoxide_cdi # Search zoxide directories
	zvm_bindkey vicmd "${leader}fa" _widget_dotbare_fadd
	zvm_bindkey vicmd "${leader}ff" _widget_dotbare_fedit
	zvm_bindkey vicmd "${leader}fg" _widget_dotbare_fgrep
	zvm_bindkey vicmd "${leader}fl" _widget_dotbare_flog
	zvm_bindkey vicmd "${leader}fS" _widget_dotbare_fstash
	zvm_bindkey vicmd "${leader}fs" _widget_dotbare_fstat
	zvm_bindkey vicmd "${leader}ga" _git_add
	zvm_bindkey vicmd "${leader}gf" _git_files
	zvm_bindkey vicmd "${leader}gg" _git_grep
	zvm_bindkey vicmd "${leader}gl" _git_log
	zvm_bindkey vicmd "${leader}gS" _git_stash
	zvm_bindkey vicmd "${leader}gs" _git_status
	zvm_bindkey vicmd "k" history-substring-search-up
	zvm_bindkey vicmd "j" history-substring-search-down
}

# Visual selection highlighting
ZVM_VI_HIGHLIGHT_BACKGROUND=#2E3C64
ZVM_VI_HIGHLIGHT_FOREGROUND=white

# Surround mode
ZVM_VI_SURROUND_BINDKEY=s-prefix

# Man
export MANWIDTH=80
if [ "${TERM}" != "linux" ]; then
	export MANROFFOPT=-P-i
fi

export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket"

eval "$(zoxide init --cmd cd zsh)"
eval "$(starship init zsh)"
eval "$(fzf --zsh)"
