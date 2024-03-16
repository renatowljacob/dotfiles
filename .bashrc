#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias cat='bat '
alias du='gdu '
alias grep='grep --color=auto '
alias lf='lfrun '
alias locate='plocate '
alias ls='lsd '
alias siv='nsxiv -a '
alias sivdir='nsxiv-rifle '
alias gconfig='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME '

PS1='[\u@\h \W]\$ '

LFCD=$HOME/.config/lf/lf.bash
if [ -f "$LFCD" ]; then
	source "$LFCD"
fi

eval "$(starship init bash)"
