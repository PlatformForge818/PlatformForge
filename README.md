# PlatformForge – Windows Platform Lab

PlatformForge is a collection of practical, read-only PowerShell tools
focused on Windows platform engineering, system health checks, and
automation-friendly workflows.

The goal of this repository is to provide small, focused tools with
clear documentation and predictable behavior, suitable for learning,
automation, and real-world usage.

---

## Project structure

windows-platform-lab/
├─ README.md
├─ CHANGELOG.md
├─ LICENSE
├─ powershell/
│ └─ win-healthcheck/
│ ├─ Win-HealthCheck.ps1
│ └─ README.md
└─ docs/
├─ overview.md
└─ tools/
└─ win-healthcheck/
├─ index.md
├─ running.md
├─ checks.md
├─ thresholds.md
├─ output.md
└─ troubleshooting.md

yaml
Code kopieren

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

➡️ **Documentation:**  
[`Win-HealthCheck documentation`](docs/tools/win-healthcheck/index.md)

➡️ **Source:**  
[`Win-HealthCheck.ps1`](powershell/win-healthcheck/Win-HealthCheck.ps1)

---

## Documentation

- Project overview: [`docs/overview.md`](docs/overview.md)
- Tool documentation lives under `docs/tools/`
- Each tool has:
  - a main documentation page
  - dedicated subpages for usage, checks, output and troubleshooting

This structure keeps the repository easy to navigate as more tools are added.

---

## Design principles

All tools in this repository follow these principles:

- Read-only by default (safe to run)
- No hard-coded paths
- Minimal dependencies
- Clear and predictable output
- Suitable for automation and scripting
- Well-documented behavior

---

## Intended audience

- Windows administrators
- Platform / infrastructure engineers
- IT learners and apprentices
- Anyone automating Windows systems with PowerShell

---

## License

This project is released under the MIT License.
