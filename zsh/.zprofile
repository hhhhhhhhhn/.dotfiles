# ~/.bash_profile
#

battery > /dev/null 2>&1 3>&1
echo "keycode 1 = Caps_Lock" | sudo loadkeys
echo "keycode 58 = Escape" | sudo loadkeys
