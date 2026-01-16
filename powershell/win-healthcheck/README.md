# Win-HealthCheck

Win-HealthCheck is a lightweight, read-only PowerShell tool that provides
a quick overview of the health and basic security state of a Windows system.

It is designed for platform and system environments where a fast,
reliable status check is required without modifying the system.

---

## Purpose

The goal of Win-HealthCheck is to answer one simple question:

**Is this Windows system in a healthy and usable state right now?**

The script focuses on essential indicators that are commonly checked
during troubleshooting, audits, or routine system validation.

---

## What the tool checks

Win-HealthCheck collects the following information:

- **Operating system**
  - Windows edition and version

- **System uptime**
  - Time since the last reboot

- **Memory**
  - Total installed physical RAM

- **Disk usage**
  - Total and free space on the system drive (C:)

- **Security status**
  - Microsoft Defender enabled state

- **Windows Update status (basic)**
  - Detects whether pending updates are available

All checks are read-only and safe to run on production systems.

---

## How it works

Win-HealthCheck follows a simple and predictable execution flow:

1. **Parameter handling**  
   An optional output parameter is processed.

2. **Data collection**  
   System information is gathered using built-in Windows APIs
   such as CIM and the Windows Update interface.

3. **Result structuring**  
   All collected values are stored in a single structured object
   to ensure consistent output.

4. **Output generation**  
   Results are displayed in the console and optionally exported as JSON.

This design keeps the script easy to understand, extend, and automate.

---

## Usage

### Run the script

From the tool directory:

```powershell
.\Win-HealthCheck.ps1
