#!/bin/bash
# =======================================================================================
# Script Name   : check_services.sh
# Description   : Audits systemd service health for specified services or default daemons.
# Author        : Haojie Dai
# Usage         : /usr/local/bin/check_services.sh [service1 service2 ...]
# Exit Codes    : 0 = All Services Operational, 2 = One or More Services Down
# =======================================================================================

set -euo pipefail

#Argument and Default Array Handling
if [ "$#" -gt 0 ]; then
    services=("$@")
else
    services=("sshd" "chronyd")
fi

failed_count=0

#Batch Auditing Loop
for service in "${services[@]}"; do
	if ! systemctl is-active --quiet "$service"; then
		echo "[FAILED] Service '$service' is not active."
		(( ++failed_count ))
	else
		echo "[OK] Service $service is running."
	fi
done

#Summary
echo "--- Service Audit Summary ---"
echo "Total services checked: ${#services[@]}
Total failed services : $failed_count"

if (( failed_count == 0 )); then
	echo "ALL SERVICES OPERATIONAL"
	exit 0
else
	echo "AUDIT FAILED: $failed_count service(s) down."
	exit 2
fi
