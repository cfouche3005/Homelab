#!/bin/bash

trap "incus_stop; exit" SIGTERM

incus_stop() {
    echo "Stopping incusd..."
    incus admin shutdown
    pkill -TERM incusd
    echo "Stopped incusd."
    echo "Stopping lxcfs..."
    pkill -TERM lxcfs
    fusermount -u /var/lib/incus-lxcfs
    echo "Stopped lxcfs."


    CHILD_PIDS=$(pgrep -P $$)
    if [ -n "$CHILD_PIDS" ]; then
        echo "Stopping child processes..."
        pkill -TERM -P $$
        echo "Stopped child processes with PIDs: $CHILD_PIDS"
    else
        echo "No child processes to stop."
    fi

    echo "Cleanup complete."
}

#set environment variables
export PATH="/opt/incus/bin/:${PATH}"
export INCUS_EDK2_PATH="/opt/incus/share/qemu/"
export LD_LIBRARY_PATH="/opt/incus/lib/"
export INCUS_LXC_TEMPLATE_CONFIG="/opt/incus/share/lxc/config/"
export INCUS_LXC_HOOK="/opt/incus/share/lxc/hooks/"
export INCUS_DOCUMENTATION="/opt/incus/doc/"
export INCUS_AGENT_PATH="/opt/incus/agent/"
export INCUS_UI="/opt/incus/ui/"

#start incus
mkdir -p /var/lib/incus-lxcfs
/opt/incus/bin/lxcfs /var/lib/incus-lxcfs --enable-loadavg --enable-cfs &
/usr/lib/systemd/systemd-udevd &
UDEVD_PID=$!
/opt/incus/bin/incusd &
sleep infinity