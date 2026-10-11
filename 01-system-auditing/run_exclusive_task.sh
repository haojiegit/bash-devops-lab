#!/bin/bash
# =======================================================================================
# Script Name   : run_exclusive_task.sh
# Description   : Use flock to guarantee that only one instance of the script can execute at a time.
# Author        : Haojie Dai
# Usage         : /usr/local/bin/run_exclusive_task.sh
# Exit Codes    : 0 =  OK 1 = Failed to acquire lock (another instance is already running)
# =======================================================================================

set -euo pipefail

#file locking implementation
lock_file="/tmp/exclusive_task.lock"

#setting file descriptor 200 to the lock_file
exec 200> "$lock_file"

if flock -n 200; then
	echo "LOCK ACQUIRED: Starting background task..."
	sleep 10 #simulate work by sleeping for 10 seconds.
	echo "TASK COMPLETE: Exiting and releasing lock."
	exit 0
else
	echo "Error: Another instance of this script is already running." >&2
	exit 1
fi
