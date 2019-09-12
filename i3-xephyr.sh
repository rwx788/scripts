#!/usr/bin/bash

function usage() {
    cat <<EOF
USAGE i3-xephyr start|stop|restart|run [options]
start Start nested i3 in xephyr
stop Stop xephyr
restart reload i3 in xephyr
run run command in nested i3
options:
-c|--config=<PATH> Path to custom i3 configuration file
EOF
}

function i3_pid() {
    /bin/pidof i3 | cut -d\  -f1
}

function xephyr_pid() {
    /bin/pidof Xephyr | cut -d\  -f1
}

[ $# -lt 1 ] && usage

for i in "$@"
do
case $i in
    start|stop|restart|run)
    COMMAND="$i"
    ;;
    -c=*|--config=*)
    I3CONFIG="${i#*=}"
    ;;
    *)
    usage
    ;;
esac
done

I3=`which i3`
XEPHYR=`which Xephyr`

test -x $I3 || {echo "i3 executable not found."}
test -x $XEPHYR || {echo "Xephyr executable not found."}

case "$COMMAND" in
    start)
	$XEPHYR -ac -br -noreset -screen 1280x720 :1 &
	sleep 1
    if [ -z "$I3CONFIG" ]; then
        DISPLAY=:1.0 $I3 &
    else
        DISPLAY=:1.0 $I3 -c $I3CONFIG &
    fi
	sleep 1
	echo I3 ready for tests. PID is $(i3_pid)
	;;
    stop)
	echo -n "Stopping nested i3..."
	if [ -z $(xephyr_pid) ]; then
	    echo "Not running: not stopped :)"
	    exit 0
	else
	    kill $(xephyr_pid)
	    echo "Done."
	fi
	;;
    restart)
	echo -n "Restarting i3..."
	kill -s SIGHUP $(xephyr_pid)
	;;
    run)
	shift
	DISPLAY=:1.0 "$@" &
	;;
    *)
	usage
	;;
esac
