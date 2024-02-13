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

PATH=$HOME/.local/bin:$PATH

ACADEMICO=$HOME/Documents/academico
TOUHOU=$HOME/Pictures/arts/touhou
AUR=$HOME/Software/AUR
GIT=$HOME/Software/git
SCRIPT=$HOME/.local/bin
SUCKLESS=$HOME/Software/git/suckless
DMENU=$HOME/Software/git/suckless/dmenu
DWM=$HOME/Software/git/suckless/dwm/dwm_raw
SLSTATUS=$HOME/Software/git/suckless/slstatus
LFCD=$HOME/.config/lf/lf.bash
if [ -f "$LFCD" ]; then
	source "$LFCD"
fi

EDITOR=nvim
export EDITOR

eval "$(starship init bash)"
