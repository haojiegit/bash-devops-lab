#!/bin/bash 
# =======================================================================================
# Script Name   : aggregate.logs.sh
# Description   : Securely creates a temporary workspace, gather log files, and gurantees 
#                 directory cleanup upon exit - even if interrupted.
# Author        : Haojie Dai
# Usage         : /usr/local/bin/aggregate_logs.sh <log_dir>
# Exit Codes    : 0 = Successful Aggregation, 1 = Invalid Input, 2 = No .log files found
# =======================================================================================

if [ "$#" -ne 1 ]; then 
        echo "Usage: /usr/local/bin/aggregate_logs.sh <log_dir>" >&2 
        exit 1 
fi 
 
#Argument must be a directory and exists. 
if [ ! -d "$1" ]; then 
        echo "Error: Directory $1 does not exist." >&2 
        exit 1 
fi 
 
#Temporary Directory & Trap Setup 
tmp_dir=$(mktemp -d /tmp/log_agg.XXXXXX) 
 
trap "rm -rf $tmp_dir" EXIT 
 
#Find all regular files in "$1" ending in ".log" and copy them into "$tmp_dir/" 
find "$1" -type f -name "*.log" -exec cp -p "{}" "$tmp_dir" \; 2>/dev/null 
 
copied_files_count="$(ls "$tmp_dir" | wc -l )" 
archive_file="/tmp/aggregated_$(date +%Y%m%d).log" 
 
#Combine log files contents into a single archive file, if at least one file was copied 
if (( copied_files_count >= 1 )) && cat "$tmp_dir"/*.log > "$archive_file" 2>/dev/null; then 
        echo "AGGREGATED: $copied_files_count log files merged into $archive_file" 
        exit 0 
else 
        echo "NO LOGS: No .log files found in $1." 
        exit 2 
fi       

