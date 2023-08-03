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
bindkey "^R" history-incremental-search-backward
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_SPACE
setopt PROMPT_SUBST

autoload -U colors

notification_number() {
	num="$(wc -l /tmp/notifications 2>/dev/null | cut -d " " -f1)"
	case "$num" in
		"")
			echo ""
			;;
		0)
			echo ""
			;;
		1)
			echo "!"
			;;
		2)
			echo "!!"
			;;
		3)
			echo "!!!"
			;;
		4)
			echo "!!!!"
			;;
		*)
			echo "!!!!!"
			;;
	esac
}

export PROMPT='%(?..%F{red}%? %f)%B%F{magenta}[%f%F{yellow}%T%f %F{cyan}%~%f%F{magenta}]$ %b%F{reset}'
export RPROMPT='%B%F{yellow}$(notification_number)%F{reset}'

TMOUT=60

TRAPALRM() {
	zle reset-prompt
}

notification_widget() {notifications; zle reset-prompt}
zle -N notification_widget

bindkey "^N" 'notification_widget'

export PATH="$PATH:/bin:$HOME/.local/bin:$HOME/Scripts:$HOME/.local/go/bin/"

export TERMINAL="st"
export EDITOR="nvim"
export BROWSER="brave"
export PAGER="less -R"
export XDG_CURRENT_DESKTOP="dwm"

export LESS="-+S "

export TODO_FILE="$HOME/Texts/todo.txt"
export FLASHCARD_FILE="$HOME/Texts/flashcard.txt"
export COLORS_DIR="$HOME/.config/colors"
export SCREENSHOT_DIR="$HOME/Images/Screenshots"
export YT_DIR="$HOME/Youtube"
export YT_FILE="$HOME/Youtube/sub"

export DICTIONARY="$HOME/Texts/dict.txt"

export GOPATH="$HOME/.local/go/:$HOME/Projects/go/"

export npm_config_prefix="$HOME/.local"

export _JAVA_AWT_WM_NONREPARENTING=1 # Prevents blank screen in android studio
export ANDROID_HOME="$HOME/Android/Sdk"
export PATH="$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools"

export MORNING_COMMAND="echo Good day!"

export LEDGER_FILE="$HOME/.hledger/main.journal"

export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/podman/podman.sock"

function chpwd() {
	ls --color=always
}

[ -f ~/.alias ] && . ~/.alias
[ -f ~/.zlocal ] && . ~/.zlocal

if [ -z $DISPLAY ] && [ `tty` = "/dev/tty1" ]; then
	startx > /dev/null 2>&1
elif tty | grep tty > /dev/null; then
	color solarized
	font
	export NCURSES_NO_UTF8_ACS=1
	clear
fi

morningprompt
true
