#!/bin/bash 
# =======================================================================================
# Script Name   : check_web_endpoint.sh
# Description   : Check whether a specified HTTP/HTTPS URL returns an expected HTTP status
#                 code within a defined timeout
# Author        : Haojie Dai
# Usage         : /usr/local/bin/check_web_endpoint.sh
# Exit Codes    : 0 = OK, 1 = Invalid Input/command 'curl' not available, 2 = Endpoint Failed
# =======================================================================================

set -euo pipefail

#Argument count check 
if [ "$#" -ne 2 ]; then
	echo "Usage: /usr/local/bin/check_web_endpoint.sh <url> <expected_status_code>" >&2
	exit 1
fi

#Expected status code validaton
if [[ ! $2 =~ ^[[:digit:]]{3}$ ]]; then
	echo "Error: Expected status code must be a 3-digit integer." >&2
	exit 1
fi

#Dependency check
if ! command -v curl &>/dev/null; then 
	echo "Error: Required command 'curl' is not installed." >&2
	exit 1
fi

#Query the target URL
actual_status="$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 5 "$1")"

#Evaluation
if [ "$actual_status" = "$2" ]; then
	echo "ENDPOINT OK: $1 returned HTTP $actual_status"
	exit 0
else
	echo "ENDPOINT FAILED: $1 returned HTTP $actual_status (Expected: $2)"
	exit 2
fi


