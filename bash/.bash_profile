#
# ~/.bash_profile
#

source .bashrc

pulseaudio --kill > /dev/null 2>&1
battery > /dev/null 2>&1 3>&1
color solarized
clear
