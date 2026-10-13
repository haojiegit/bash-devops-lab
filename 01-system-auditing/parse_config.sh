#!/bin/bash
# =======================================================================================
# Script Name   : parse_config.sh
# Description   : take a path to a configuration file as a command-line argument, safely
#                 parses its key-value pairs, and prints them out in a structured format.
# Author        : Haojie Dai
# Usage         : /usr/local/bin/parse_config.sh
# Exit Codes    : 0 = Successful Parsing; 1 = Invalid Input 
# =======================================================================================

set -euo pipefail

#Input validation
if [ "$#" -ne 1 ]; then
	echo "Usage: /usr/local/bin/parse_config.sh <config_file>" >&2
	exit 1
fi

target_cfg_file_path="$1"

if [ ! -f "$target_cfg_file_path" ]; then
	echo "Error: Config file $target_cfg_file_path not found." >&2
	exit 1
fi

#Parsing config_file
while IFS= read -r line || [ -n "$line" ]; do
	[[ -z $line || $line =~ ^[[:space:]]*# ]] && continue
	key="$(echo "$line" | cut -d "=" -f 1 | xargs)"
	value="$(echo "$line" | cut -d "=" -f 2- | xargs)"

	echo "[CONFIG] $key -> $value"
done < "$target_cfg_file_path"

exit 0
