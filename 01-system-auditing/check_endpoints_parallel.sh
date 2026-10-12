#!/bin/bash
# =======================================================================================
# Script Name   : check_endpoints_parallel.sh
# Description   : accepts a list of URLs as command-line arguments (or defaults to a standard
#                 list if none are provided); check all endpoints in parallel using background
#                 jobs and wait.
# Author        : Haojie Dai
# Usage         : /usr/local/bin/check_endpoints_parallel.sh
# Exit Codes    : 0 =  Parallel Audit Complete 
# =======================================================================================

set -euo pipefail

#Argument & Default Array Handling
if [ "$#" -gt 0 ]; then
	target_array=("$@")
else
	target_array=("https://httpbin.org/status/200" "https://httpbin.org/status/500" "https://httpbin.org/status/200")
fi

#Paralle Execution Loop
for url in "${target_array[@]}"; do
	(
          status=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 5 "$url" || echo "000")
	  if [ "$status" -eq 200 ]; then
	      echo "[OK] $url returned HTTP $status"
	  else
	      echo "[FAILED] $url returned HTTP $status"
	  fi
	) &
done

#Synchronize background jobs
wait

echo "--- Parallel Audit Complete ---"
exit 0
