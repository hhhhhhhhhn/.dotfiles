#
# ~/.bash_profile
#

pulseaudio --kill > /dev/null 2>&1
battery > /dev/null 2>&1 3>&1
color solarized
echo "keycode 1 = Caps_Lock" | sudo loadkeys
echo "keycode 58 = Escape" | sudo loadkeys
clear

source .bashrc
