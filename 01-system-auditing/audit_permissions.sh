#!/bin/bash
# =======================================================================================
# Script Name   : audit_permissions.sh
# Description   : scan a specified directory path for world-writable files and reports any vulnerabilities found.
# Author        : Haojie Dai
# Usage         : /usr/local/bin/audit_permissions <directory>
# Exit Codes    : 0 =  OK 1 = Invalid Input 2 = One or More World-writable files found
# =======================================================================================

set -euo pipefail

#Positional Parameters & Validation
if [ "$#" -ne 1 ]; then
        echo "Usage: /usr/local/bin/audit_permissions.sh <target_directory>" >&2
        exit 1
fi

if [ ! -d "$1" ]; then
        echo "Error: Target path '$1' is not a valid directory." >&2
        exit 1
fi

count=0

#Security Scan Execution and Evaluation
while IFS= read -r  filepath || [ -n "$filepath" ]; do
        [ -z "$filepath" ] && continue
        echo "$filepath"
        (( ++count ))
done < <(find "$1" -type f -perm -002 2>/dev/null)

if (( count == 0 )); then
        echo "SECURITY OK: No world-writable files found in $1."
        exit 0
else
        echo "SECURITY WARNING: Found $count world-writable file(s) in $1."
        exit 2
fi
