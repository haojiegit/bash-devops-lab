#!/bin/bash 
# =======================================================================================
# Script Name   : check_node_status.sh
# Description   : Parse .jason status file using jq and evaluates cluster health
# Author        : Haojie Dai
# Usage         : /usr/local/bin/check_node_status.sh
# Exit Codes    : 0 = OK, 1 = Invalid Input, 2 = Unhealthy Node
# =======================================================================================

#Assume /etc/node_info.json has the following content
#{
# "hostname": "node-01.lab.internal",
# "environment": "production",
# "status": "active",
# "services_failed": 0
#}

set -euo pipefail

#Ensure jq is installed
if ! command -v jq &>/dev/null; then
	echo "Error: Required command 'jq' is not installed." >&2
	exit 1
fi

target_file="/etc/node_info.json"
#Ensure target file argument exist and is readable
if [ ! -r "$target_file" ]; then
	echo "Error: Status file /etc/node_info.json is unreadable." >&2
	exit 1
fi

#JASON extraction
hostname="$(jq -r '.hostname' "$target_file")" 

environment="$(jq -r '.environment' "$target_file")" 

status="$(jq -r '.status' "$target_file")" 

services_failed="$(jq -r '.services_failed' "$target_file")" 

#Health Evaluation
if [ "$status" = "active" ] && [ "$services_failed" -eq 0 ]; then
	echo "NODE HEALTHY: $hostname ($environment) - Status: active, Failed Services: 0"
	exit 0
else
	echo "NODE UNHEALTHY: $hostname ($environment) - Status: $status, Failed Services: $services_failed"
	exit 2
fi

