# Bash DevOps & Systems Automation Lab

Production-grade Bash scripts for Linux system administration, security auditing, and DevOps automation. Built with enterprise resilience standards, strict error handling, and robust data parsing.

---

## Key Design Principles

* **Strict Execution Mode:** Mandatory use of `set -euo pipefail` for immediate error trapping and pipeline failure propagation.
* **Safe Workspaces:** Secure temporary file generation using `mktemp -d` and guaranteed cleanup via `trap` signal handlers.
* **Structured Data Handling:** Native JSON parsing with `jq` to ensure safe, schema-aware data extraction.
* **Standardized Status Codes:** Consistent exit codes across all utilities:
  * `0` = Success / Healthy / Within Threshold
  * `1` = Invalid Input / Usage Error / Missing Dependency
  * `2` = Threshold Exceeded / Unhealthy State

---

## Repository Structure & Script Catalog

| Category | Script | Description | Exit Codes |
| :--- | :--- | :--- | :--- |
| **System Auditing** | [`aggregate_logs.sh`](01-system-auditing/aggregate_logs.sh) | Stages active `.log` files in a isolated `mktemp` workspace and concatenates them into a single archive. Features automated `trap` cleanup. | `0` = Success<br>`1` = Invalid Dir<br>`2` = No Logs |
| **System Auditing** | [`check_filesystem.sh`](01-system-auditing/check_filesystem.sh) | Audits mount point disk space against configurable percentage thresholds using portable POSIX `df -P` parsing. | `0` = OK<br>`1` = Invalid Arg<br>`2` = Critical |
| **System Auditing** | [`check_node_status.sh`](01-system-auditing/check_node_status.sh) | Validates dependency on `jq` and evaluates cluster node health from structured JSON status files (`/etc/node_info.json`). | `0` = Healthy<br>`1` = Error/Missing `jq`<br>`2` = Unhealthy |
| **System Auditing** | [`check_web_endpoint.sh`](01-system-auditing/check_web_endpoint.sh) | Queries HTTP/HTTPS endpoints using `curl` with connection timeout limits and validates HTTP status codes against target expectations. | `0` = OK<br>`1` = Error/Missing `curl`<br>`2` = Endpoint Failed |

---

## Quick Start

1. Clone the repository:
   ```bash
   git clone [https://github.com/haojiegit/bash-devops-lab.git](https://github.com/haojiegit/bash-devops-lab.git)
   cd bash-devops-lab
   ```
2. Make scripts executable:
   ```bash
   chmod +x 01-system-auditing/*.sh
   ```
3. Run an audit check (example):
   ```bash
   ./01-system-auditing/check_web_endpoint.sh [https://httpbin.org/status/200](https://httpbin.org/status/200) 200
   ```
