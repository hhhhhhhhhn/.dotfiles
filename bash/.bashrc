#
# ~/.bashrc
#

set -o vi

export PATH="$PATH:/bin:~/Scripts"

export EDITOR="nvim"
export LESS="-+S "

export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

export NOTES_DIR="/home/persona/Notes"
export TODO_FILE="/home/persona/Notes/todo.txt"
export COLORS_DIR="/home/persona/.config/colors"

[[ -f ~/.bash_alias ]] && . ~/.bash_alias
[[ -f ~/.bash_local ]] && . ~/.bash_local

