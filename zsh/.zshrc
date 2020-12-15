#
# ~/.zshrc
#

set -o emacs

export TERM="xterm-256color"
export PROMPT='%(?..%F{red}%? %f)%(!.%F{red}.)%B[%T %~]$ %b%F{reset}'

export PATH="$PATH:/bin:$HOME/.local/bin:$HOME/Scripts"

export EDITOR="vim"
export LESS="-+S "

export NOTES_DIR="/home/persona/Notes"
export TODO_FILE="/home/persona/Notes/todo.txt"
export COLORS_DIR="/home/persona/.config/colors"
export YT_DIR="/home/persona/Youtube/"
export YT_FILE="/home/persona/Youtube/sub"

color solarized
clear

[ -f ~/.alias ] && . ~/.alias
[ -f ~/.zlocal ] && . ~/.zlocal
