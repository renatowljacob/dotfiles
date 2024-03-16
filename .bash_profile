#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

PATH=$HOME/.local/bin:$PATH
export PATH

XDG_CONFIG_HOME=$HOME/.config
export XDG_CONFIG_HOME

XDG_DATA_HOME=$HOME/.local/share
export XDG_DATA_HOME

XDG_STATE_HOME=$HOME/.local/state
export XDG_STATE_HOME

XDG_CACHE_HOME=$HOME/.cache
export XDG_CACHE_HOME

EDITOR=nvim
export EDITOR
