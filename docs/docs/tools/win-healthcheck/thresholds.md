# HealthStatus and thresholds

## HealthStatus
- **OK**: system looks healthy
- **WARNING**: attention recommended
- **CRITICAL**: immediate action recommended

## Exit codes (automation)
- `0` → OK
- `1` → WARNING
- `2` → CRITICAL

## Default thresholds
- Disk free space:
  - WARNING < 15%
  - CRITICAL < 10%
- Uptime:
  - WARNING > 30 days
  - CRITICAL > 60 days
- Pending Windows updates → at least WARNING
- Defender disabled → CRITICAL

## Custom thresholds
```powershell
.\Win-HealthCheck.ps1 -WarnDiskFreePct 20 -CritDiskFreePct 12 -WarnUptimeDays 14 -CritUptimeDays 30
yaml
Code kopieren
```
---

## 5) `output.md` (Ausgabe erklären + Beispiele)

# Output

Win-HealthCheck provides:
- **Console output** (human-readable)
- **JSON output** (automation-friendly) via `-JsonOut`

## Example console output
```text
HealthStatus     : OK
ExitCode         : 0
DiskFreePct      : 32.10
UpdatesPending   : False
DefenderEnabled  : True
Example JSON output
json
Code kopieren
{
  "HealthStatus": "OK",
  "ExitCode": 0,
  "DiskFreePct": 32.1,
  "UpdatesPending": false,
  "DefenderEnabled": true
}
yaml
Code kopieren
```
---

## 6) `troubleshooting.md` (Fehlerhilfe)


# Troubleshooting

## "running scripts is disabled"
Use PowerShell (not CMD) and run:
```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
File not found
Make sure you are in the correct directory:

powershell
Code kopieren
cd .\powershell\win-healthcheck
dir
Defender status is "Unknown"
This can happen if Defender is not available or access is restricted.
The script continues safely.

yaml
Code kopieren
```
---

## 7) Tool-README kurz machen und auf die Doku verlinken

`powershell/win-healthcheck/README.md` **kurz & professionell**:

```
# Win-HealthCheck

PowerShell-based Windows health check with HealthStatus (OK/WARNING/CRITICAL),
exit codes (0/1/2), and optional JSON output.
```
## Documentation
- Main page: [`docs/tools/win-healthcheck/index.md`](../../docs/tools/win-healthcheck/index.md)

## Source
- [`Win-HealthCheck.ps1`](Win-HealthCheck.ps1)
