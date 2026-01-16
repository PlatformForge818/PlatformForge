# Running Win-HealthCheck

## Prerequisites
- Windows 10/11
- Windows PowerShell
- Repository downloaded or cloned locally

## Run from repository root
```powershell
.\powershell\win-healthcheck\Win-HealthCheck.ps1
Run from tool directory
powershell
Code kopieren
cd .\powershell\win-healthcheck
.\Win-HealthCheck.ps1
Temporary execution policy (current session only)
powershell
Code kopieren
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
JSON output
powershell
Code kopieren
.\Win-HealthCheck.ps1 -JsonOut .\health.json
yaml
Code kopieren
```
---

## 3) `checks.md` (Was geprüft wird)

```md
# Checks

Win-HealthCheck performs read-only checks:

- **Operating system**: Windows edition and version
- **Uptime**: days since last boot
- **Memory**: total installed physical RAM
- **Disk (C:)**: total, free and free percentage
- **Microsoft Defender**: enabled state (if available)
- **Windows Update (basic)**: pending updates (true/false/unknown)

All checks are safe and do not modify system state.
