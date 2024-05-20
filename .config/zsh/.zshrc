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
  zsh-users/zsh-autosuggestions
  zsh-users/zsh-syntax-highlighting
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
alias grep='grep --color=auto '
alias lf='lfrun '
alias locate='plocate '
alias ls='lsd '
alias siv='nsxiv -a '
alias sivdir='nsxiv-rifle '
alias gconfig='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME '
alias rm='trash '
alias devpod-start='/opt/devpod/devpod.AppImage'

bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

LFCD=$HOME/.config/lf/lf.bash
if [ -f "$LFCD" ]; then
	emulate ksh -c 'source $LFCD'
fi

eval "$(zoxide init --cmd cd zsh)"
eval "$(starship init zsh)"
eval "$(fzf --zsh)"
