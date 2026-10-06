# Bash DevOps & Systems Automation Lab

Production-grade Bash scripts for Linux system administration, security auditing, and DevOps automation.

## Repository Structure

| Category | Script | Description |
| :--- | :--- | :--- |
| **System Auditing** | `01-system-auditing/aggregate_logs.sh` | Safely stages and merges `.log` files using `mktemp` workspaces and `trap` signal handlers. |
| **System Auditing** | `01-system-auditing/check_filesystem.sh` | Audits mount point disk space against thresholds using `set -euo pipefail` strict mode. |

