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

TOUHOU=/home/espritmakomako/Pictures/arts/touhou
AUR=/home/espritmakomako/Software/AUR
GIT=/home/espritmakomako/Software/git
SUCKLESS=/home/espritmakomako/Software/git/suckless
DWM=/home/espritmakomako/Software/git/suckless/dwm/dwm_raw
DMENU=/home/espritmakomako/Software/git/suckless/dmenu
SLSTATUS=/home/espritmakomako/Software/git/suckless/slstatus
ACADEMICO=/home/espritmakomako/Documents/academico
LFCD=/home/espritmakomako/.config/lf/lf.bash
if [ -f "$LFCD" ]; then
	source "$LFCD"
fi

EDITOR=nvim
export EDITOR

eval "$(starship init bash)"
