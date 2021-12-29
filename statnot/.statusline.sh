if [ $# -eq 1 ]; then
	notifications="$( (cat /tmp/notifications; echo "$1") | uniq )"
	echo "$notifications" > /tmp/notifications
fi
