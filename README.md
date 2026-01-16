# PlatformForge – Windows Platform Lab

PlatformForge is a collection of practical, read-only PowerShell tools
focused on Windows platform engineering, system health checks, and
automation-friendly workflows.

The repository is structured around individual tools, each with its own
dedicated documentation pages.

---

## Tools

### Win-HealthCheck
A lightweight Windows health check tool with automation support.

**Features**
- OS, uptime, memory and disk checks
- Microsoft Defender status
- Windows Update basic status
- HealthStatus evaluation (OK / WARNING / CRITICAL)
- Exit codes (0 / 1 / 2)
- Optional JSON output for automation

**Documentation**
- Main page:  
  [`Win-HealthCheck overview`](docs/tools/win-healthcheck/index.md)
- How to run the tool:  
  [`Running the tool`](docs/tools/win-healthcheck/running.md)
- What is checked:  
  [`Checks`](docs/tools/win-healthcheck/checks.md)
- Health thresholds & exit codes:  
  [`Thresholds`](docs/tools/win-healthcheck/thresholds.md)
- Output formats (text / JSON):  
  [`Output`](docs/tools/win-healthcheck/output.md)
- Common issues:  
  [`Troubleshooting`](docs/tools/win-healthcheck/troubleshooting.md)

**Source**
- [`Win-HealthCheck.ps1`](powershell/win-healthcheck/Win-HealthCheck.ps1)

---

## Documentation overview

- Project overview:  
  [`docs/overview.md`](docs/overview.md)
- Tool documentation lives under:  
  [`docs/tools/`](docs/tools/)

Each tool has:
- one main documentation page
- multiple subpages covering usage, checks, output and troubleshooting

---

## Design principles

All tools in this repository follow these principles:

- Read-only by default (safe to run)
- No hard-coded paths
- Minimal dependencies
- Clear and predictable output
- Automation-friendly design
- Clear and structured documentation

---

## Intended audience

- Windows administrators
- Platform / infrastructure engineers
- IT learners and apprentices
- Anyone automating Windows systems with PowerShell

---

## License

This project is released under the MIT License.
