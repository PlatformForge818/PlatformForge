# Win-HealthCheck

Win-HealthCheck is a read-only PowerShell tool that provides a quick overview of
Windows system health and basic security state.

## What it does
- Collects OS, uptime, memory and disk information
- Checks Microsoft Defender status
- Checks pending Windows Updates (basic)
- Evaluates an overall **HealthStatus** (OK/WARNING/CRITICAL)
- Returns **exit codes** (0/1/2) for automation

## Quick links
- [How to run it](running.md)
- [What is checked](checks.md)
- [Health thresholds](thresholds.md)
- [Output formats (Text/JSON)](output.md)
- [Troubleshooting](troubleshooting.md)

## Source
- Script: [`Win-HealthCheck.ps1`](../../../powershell/win-healthcheck/Win-HealthCheck.ps1)
