<#
.SYNOPSIS
    Provides a basic health overview of a Windows system.

.DESCRIPTION
    Win-HealthCheck is a read-only PowerShell script that collects essential
    system and security information from a Windows machine. It also evaluates
    a HealthStatus (OK/WARNING/CRITICAL) and returns an exit code suitable
    for automation and monitoring.

.PARAMETER JsonOut
    Optional path to export the collected data as a JSON file.

.PARAMETER WarnDiskFreePct
    Disk free percentage below this triggers WARNING. Default: 15

.PARAMETER CritDiskFreePct
    Disk free percentage below this triggers CRITICAL. Default: 10

.PARAMETER WarnUptimeDays
    Uptime above this triggers WARNING. Default: 30

.PARAMETER CritUptimeDays
    Uptime above this triggers CRITICAL. Default: 60

.PARAMETER Quiet
    If set, suppresses formatted console output (still writes JSON if requested).

.EXAMPLE
    .\Win-HealthCheck.ps1

.EXAMPLE
    .\Win-HealthCheck.ps1 -JsonOut .\health.json

.EXAMPLE
    .\Win-HealthCheck.ps1 -WarnDiskFreePct 20 -CritDiskFreePct 12
#>

param(
    [string]$JsonOut,

    [ValidateRange(1,100)]
    [int]$WarnDiskFreePct = 15,

    [ValidateRange(1,100)]
    [int]$CritDiskFreePct = 10,

    [ValidateRange(1,3650)]
    [int]$WarnUptimeDays = 30,

    [ValidateRange(1,3650)]
    [int]$CritUptimeDays = 60,

    [switch]$Quiet
)

# ----------------------------
# Helper: severity comparison
# ----------------------------
function Get-SeverityValue {
    param([string]$Status)
    switch ($Status) {
        "OK"       { return 0 }
        "WARNING"  { return 1 }
        "CRITICAL" { return 2 }
        default    { return 0 }
    }
}

function Set-MaxSeverity {
    param(
        [string]$Current,
        [string]$Candidate
    )
    if ((Get-SeverityValue $Candidate) -gt (Get-SeverityValue $Current)) {
        return $Candidate
    }
    return $Current
}

# ----------------------------
# Collect system information
# ----------------------------
$os = Get-CimInstance Win32_OperatingSystem
$computer = Get-CimInstance Win32_ComputerSystem
$disk = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"

$uptime = (Get-Date) - $os.LastBootUpTime
$uptimeDays = [math]::Round($uptime.TotalDays, 2)

# Disk numbers (handle unknown)
$diskTotalGB = $null
$diskFreeGB = $null
$diskFreePct = $null

if ($disk -and $disk.Size -gt 0) {
    $diskTotalGB = [math]::Round($disk.Size / 1GB, 2)
    $diskFreeGB  = [math]::Round($disk.FreeSpace / 1GB, 2)
    $diskFreePct = [math]::Round(($disk.FreeSpace / $disk.Size) * 100, 2)
}

# Defender status (may be unavailable)
$defenderEnabled = "Unknown"
try {
    $defenderStatus = Get-MpComputerStatus
    $defenderEnabled = $defenderStatus.AntivirusEnabled
} catch {
    $defenderEnabled = "Unknown"
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
# Evaluate health
# ----------------------------
$healthStatus = "OK"
$issues = New-Object System.Collections.Generic.List[string]

# Disk evaluation
if ($diskFreePct -ne $null) {
    if ($diskFreePct -lt $CritDiskFreePct) {
        $healthStatus = Set-MaxSeverity $healthStatus "CRITICAL"
        $issues.Add("Disk free space CRITICAL: $diskFreePct% (< $CritDiskFreePct%)")
    } elseif ($diskFreePct -lt $WarnDiskFreePct) {
        $healthStatus = Set-MaxSeverity $healthStatus "WARNING"
        $issues.Add("Disk free space WARNING: $diskFreePct% (< $WarnDiskFreePct%)")
    }
} else {
    $healthStatus = Set-MaxSeverity $healthStatus "WARNING"
    $issues.Add("Disk information unavailable (C:).")
}

# Uptime evaluation
if ($uptimeDays -gt $CritUptimeDays) {
    $healthStatus = Set-MaxSeverity $healthStatus "CRITICAL"
    $issues.Add("Uptime CRITICAL: $uptimeDays days (> $CritUptimeDays)")
} elseif ($uptimeDays -gt $WarnUptimeDays) {
    $healthStatus = Set-MaxSeverity $healthStatus "WARNING"
    $issues.Add("Uptime WARNING: $uptimeDays days (> $WarnUptimeDays)")
}

# Updates evaluation
if ($updatesPending -eq $true) {
    $healthStatus = Set-MaxSeverity $healthStatus "WARNING"
    $issues.Add("Pending Windows Updates detected.")
} elseif ($updatesPending -eq "Unknown") {
    $healthStatus = Set-MaxSeverity $healthStatus "WARNING"
    $issues.Add("Windows Update status unknown.")
}

# Defender evaluation
if ($defenderEnabled -eq $false) {
    $healthStatus = Set-MaxSeverity $healthStatus "CRITICAL"
    $issues.Add("Microsoft Defender is disabled.")
} elseif ($defenderEnabled -eq "Unknown") {
    $healthStatus = Set-MaxSeverity $healthStatus "WARNING"
    $issues.Add("Microsoft Defender status unknown.")
}

# Exit code mapping
$exitCode = Get-SeverityValue $healthStatus

# ----------------------------
# Build result object
# ----------------------------
$result = [ordered]@{
    ComputerName      = $env:COMPUTERNAME
    OSName            = $os.Caption
    OSVersion         = $os.Version

    UptimeDays        = $uptimeDays

    MemoryTotalGB     = [math]::Round($computer.TotalPhysicalMemory / 1GB, 2)

    DiskTotalGB       = if ($diskTotalGB -ne $null) { $diskTotalGB } else { "Unknown" }
    DiskFreeGB        = if ($diskFreeGB  -ne $null) { $diskFreeGB  } else { "Unknown" }
    DiskFreePct       = if ($diskFreePct -ne $null) { $diskFreePct } else { "Unknown" }

    DefenderEnabled   = $defenderEnabled
    UpdatesPending    = $updatesPending

    HealthStatus      = $healthStatus
    ExitCode          = $exitCode
    Issues            = $issues

    Timestamp         = (Get-Date).ToString("s")
}

# ----------------------------
# Output
# ----------------------------
if (-not $Quiet) {
    $result | Format-List
}

# Optional JSON output
if ($JsonOut) {
    try {
        $parent = Split-Path -Parent $JsonOut
        $leaf = Split-Path -Leaf $JsonOut

        $targetDir = $null
        if ([string]::IsNullOrWhiteSpace($parent)) {
            $targetDir = (Get-Location).Path
        } else {
            if (Test-Path -LiteralPath $parent) {
                $targetDir = (Resolve-Path -LiteralPath $parent).Path
            } else {
                $targetDir = (Get-Location).Path
            }
        }

        $fullJsonPath = Join-Path $targetDir $leaf
        $result | ConvertTo-Json -Depth 5 | Out-File -FilePath $fullJsonPath -Encoding utf8
    } catch {
        Write-Warning "Failed to write JSON output."
    }
}

exit $exitCode
