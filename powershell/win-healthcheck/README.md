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

```md
## How to run Win-HealthCheck locally

Win-HealthCheck is executed directly on the Windows system you want to inspect.
The script runs locally and collects live system information.

---

### Prerequisites
- Windows 10 or Windows 11
- Windows PowerShell
- The repository downloaded or cloned to your local machine

---

### Step 1: Open PowerShell

Open **Windows PowerShell** (not Command Prompt).

You should see a prompt like:
```

PS C:\Users\yourname>

````

---

### Step 2: Navigate to the script directory

Use `cd` to move into the directory containing the script:

```powershell
cd powershell\win-healthcheck
````

Verify the files:

```powershell
dir
```

You should see:

```
Win-HealthCheck.ps1
README.md
```

---

### Step 3: Allow script execution (temporary)

PowerShell blocks scripts by default.
Allow execution for the current session only:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

This does not change system-wide security settings.

---

### Step 4: Run the script

```powershell
.\Win-HealthCheck.ps1
```

The script will immediately output the system health information to the console.

---

### Optional: JSON output (for automation)

```powershell
.\Win-HealthCheck.ps1 -JsonOut .\health.json
```

This creates a JSON file in the current directory containing the same data.

### Notes

* The script is read-only and safe to run
* No system changes are performed
* All data is collected locally from the target system

```


```

From the tool directory:

```powershell
.\Win-HealthCheck.ps1
