<#
.SYNOPSIS
    Provides a basic health overview of a Windows system.

.DESCRIPTION
    Win-HealthCheck is a read-only PowerShell script that collects
    essential system and security information from a Windows machine.
    It is designed for quick diagnostics and automation-friendly usage.

.PARAMETER JsonOut
    Optional path to export the collected data as a JSON file.

.EXAMPLE
    .\Win-HealthCheck.ps1

.EXAMPLE
    .\Win-HealthCheck.ps1 -JsonOut .\health.json
#>

param(
    [string]$JsonOut
)

# ----------------------------
# Collect system information
# ----------------------------

# Operating system information
$os = Get-CimInstance Win32_OperatingSystem

# Hardware information
$computer = Get-CimInstance Win32_ComputerSystem

# Disk information (system drive)
$disk = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"

# Calculate uptime
$uptime = (Get-Date) - $os.LastBootUpTime

# Microsoft Defender status
$defenderStatus = $null
try {
    $defenderStatus = Get-MpComputerStatus
} catch {
    $defenderStatus = $null
}

# ----------------------------
# Windows Update (basic check)
# ----------------------------

$updatesPending = "Unknown"

try {
    $updateSession = New-Object -ComObject Microsoft.Update.Session
    $updateSearcher = $updateSession.CreateUpdateSearcher()
    $searchResult = $updateSearcher.Search("IsInstalled=0")

    if ($searchResult.Updates.Count -gt 0) {
        $updatesPending = $true
    } else {
        $updatesPending = $false
    }
} catch {
    $updatesPending = "Unknown"
}

# ----------------------------
# Build result object
# ----------------------------

$result = [ordered]@{
    ComputerName      = $env:COMPUTERNAME
    OSName            = $os.Caption
    OSVersion         = $os.Version
    UptimeDays        = [math]::Round($uptime.TotalDays, 2)

    MemoryTotalGB     = [math]::Round($computer.TotalPhysicalMemory / 1GB, 2)

    DiskTotalGB       = if ($disk) { [math]::Round($disk.Size / 1GB, 2) } else { "Unknown" }
    DiskFreeGB        = if ($disk) { [math]::Round($disk.FreeSpace / 1GB, 2) } else { "Unknown" }

    DefenderEnabled   = if ($defenderStatus) { $defenderStatus.AntivirusEnabled } else { "Unknown" }

    UpdatesPending    = $updatesPending

    Timestamp         = (Get-Date).ToString("s")
}

# ----------------------------
# Output
# ----------------------------

# Human-readable output
$result | Format-List

# Optional JSON output
if ($JsonOut) {
    try {
        $jsonPath = Resolve-Path -Path (Split-Path -Parent $JsonOut) -ErrorAction SilentlyContinue

        if (-not $jsonPath) {
            $jsonPath = Get-Location
        }

        $fullJsonPath = Join-Path $jsonPath.Path (Split-Path $JsonOut -Leaf)

        $result | ConvertTo-Json -Depth 3 | Out-File -FilePath $fullJsonPath -Encoding utf8
    } catch {
        Write-Warning "Failed to write JSON output."
    }
}

