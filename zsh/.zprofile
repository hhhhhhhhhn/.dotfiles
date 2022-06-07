# ~/.bash_profile
#

command -v doas >/dev/null && SUDO=doas || SUDO=sudo

battery > /dev/null 2>&1 3>&1
echo "keycode 1 = Caps_Lock" | $SUDO loadkeys
echo "keycode 58 = Escape" | $SUDO loadkeys
