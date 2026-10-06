#!/bin/bash 
# =======================================================================================
# Script Name   : check_filesystem.sh
# Description   : Checks a specific mount point against a usage threshold percentage and
#                 runs safely under strict execution mode
# Author        : Haojie Dai
# Usage         : /usr/local/bin/check_filesystem.sh <mount_point> <threshold_pct>
# Exit Codes    : 0 = OK (Usage <= Threshold, 1 = Invalid Input, 2 = Usage > Threshold 
# =======================================================================================

#Enable strict error handling
set -euo pipefail

#Argument count check
if [ "$#" -ne 2 ]; then
	echo "Usage: /usr/local/bin/check_filesystem.sh <mount_point> <threshold_pct>" >&2
	exit 1
fi 

#Mount point check 
if [ ! -d "$1" ]; then 
	echo "Error: Mount point $1 is invalid." >&2
	exit 1
fi 

#Threshold integer check
if [[ "$2" =~ ^[[:digit:]]+$ ]] && (( $2 >=1 && $2 <=99 )); then
	:
else
	echo "Error: Threshold must be an integer between 1 and 99." >&2
	exit 1
fi 

#Filesystem Usage Calculation 
used_pct="$(df -P "$1" | awk 'NR==2 {print $5}' | tr -d "%")"

if (( used_pct > $2 )); then 
	echo "CRITICAL: $1 usage at ${used_pct}% (Threshold: ${2}%)"
	exit 2
else
	echo "OK: $1 usage at ${used_pct}% (Threshold: ${2}%)"
	exit 0
fi 
