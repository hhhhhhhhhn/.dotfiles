#
# ~/.zshrc
#

case $- in
	*i*) ;;
	*) exit 1;;
esac

set -o vi
unsetopt BEEP

HISTFILE=~/.zhist
HISTSIZE=5000
SAVEHIST=5000
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_SPACE

autoload -U colors

export TERM="xterm-256color"
export TERMINAL="urxvt"
export PROMPT='%(?..%F{red}%? %f)%B%F{magenta}[%f%F{yellow}%T%f %F{cyan}%~%f%F{magenta}]$ %b%F{reset}'

export PATH="$PATH:/bin:$HOME/.local/bin:$HOME/Scripts"

export EDITOR="nvim"
export LESS="-+S "

export NOTES_DIR="$HOME/Notes"
export TODO_FILE="$HOME/Notes/todo.txt"
export COLORS_DIR="$HOME/.config/colors"
export YT_DIR="$HOME/Youtube"
export YT_FILE="$HOME/Youtube/sub"

export GOPATH="$HOME/.local/go/:$HOME/Projects/go/"

function chpwd() {
	ls --color=always
}

[ -f ~/.alias ] && . ~/.alias
[ -f ~/.zlocal ] && . ~/.zlocal

if [ -z $DISPLAY ] && [ `tty` = "/dev/tty1" ]; then
	x > /dev/null 2>&1
elif tty | grep tty > /dev/null; then
	color solarized
	font
	export NCURSES_NO_UTF8_ACS=1
	clear
fi

true
