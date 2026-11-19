<#
.SYNOPSIS
  Watches the RuneScape client's memory while you use the plugin, and logs it to a CSV.

.DESCRIPTION
  The plugin's own memory probe (dev/memprobe.lua) sees the Lua heap and the components the plugin has made. It cannot see
  the client's own memory (models, textures the client keeps). This script watches the whole client process from outside,
  every couple of seconds, so the two can be read together.

  While it runs, press
    m   to put a marker in the log. Press it each time you finish one round (for example each time you press Done after
        opening 10 packs). The marker's number is the number in the plugin's "MEM reveal closed #N" line.
    b   to mark a baseline (do it first, with every plugin window closed).
    q   to stop. It prints a table of the markers and how much memory changed between them.

  Run it in a normal PowerShell window (not the VS Code Output pane), from anywhere:
    powershell -ExecutionPolicy Bypass -File dev\memwatch.ps1
  Name the process if it is not found by itself (Task Manager > Details shows it, without ".exe"):
    powershell -ExecutionPolicy Bypass -File dev\memwatch.ps1 -Name rs2client

  Nothing is changed or sent anywhere. It only reads the process's memory figures, and writes
  dev\memwatch_<date>_<time>.csv (git ignores those).

  "Private" is the memory the client alone is holding (the number to watch). "Working set" is the part of it in RAM now.
#>
param(
    [string]$Name = "",
    [int]$IntervalSeconds = 2
)

$ErrorActionPreference = "Stop"

function Find-Client {
    param([string]$Name)
    if ($Name -ne "") {
        return @(Get-Process -Name $Name -ErrorAction SilentlyContinue)
    }
    $found = @(Get-Process | Where-Object { $_.MainWindowTitle -like "RuneScape*" })
    if ($found.Count -eq 0) {
        foreach ($guess in @("rs2client", "RuneScape", "rs2client_beta")) {
            $found = @(Get-Process -Name $guess -ErrorAction SilentlyContinue)
            if ($found.Count -gt 0) { break }
        }
    }
    return $found
}

$candidates = Find-Client -Name $Name
if ($candidates.Count -eq 0) {
    Write-Host "Could not find the RuneScape client. Start it first, or give the process name with -Name (see Task Manager > Details)." -ForegroundColor Yellow
    exit 1
}
$process = $candidates | Sort-Object PrivateMemorySize64 -Descending | Select-Object -First 1
Write-Host ("Watching {0} (process id {1}). Press m for a marker, b for a baseline, q to stop." -f $process.ProcessName, $process.Id)

$csv = Join-Path $PSScriptRoot ("memwatch_{0}.csv" -f (Get-Date -Format "yyyy-MM-dd_HHmmss"))
"time,elapsed_s,private_mb,working_set_mb,marker" | Out-File -FilePath $csv -Encoding utf8
Write-Host ("Logging to {0}" -f $csv)

$start = Get-Date
$markers = @()          # { Label, Private, Elapsed }
$markerCount = 0
$peak = 0.0
$first = $null

# The key pressed, or $null. (Without a console, for example when run from another tool, keys are ignored and Ctrl+C stops it.)
function Read-Key {
    try {
        if ([Console]::KeyAvailable) { return [Console]::ReadKey($true).KeyChar }
    } catch {
        return $null
    }
    return $null
}

function Take-Reading {
    $process.Refresh()
    return [pscustomobject]@{
        Private    = [math]::Round($process.PrivateMemorySize64 / 1MB, 1)
        WorkingSet = [math]::Round($process.WorkingSet64 / 1MB, 1)
    }
}

function Add-Row {
    param($Reading, [string]$Marker)
    $now = Get-Date
    $line = "{0},{1},{2},{3},{4}" -f $now.ToString("HH:mm:ss"), [math]::Round(($now - $start).TotalSeconds, 0), $Reading.Private, $Reading.WorkingSet, $Marker
    Add-Content -Path $csv -Value $line -Encoding utf8
}

try {
    while ($true) {
        if ($process.HasExited) {
            Write-Host "The client has closed." -ForegroundColor Yellow
            break
        }
        $reading = Take-Reading
        if ($first -eq $null) { $first = $reading.Private }
        if ($reading.Private -gt $peak) { $peak = $reading.Private }
        Add-Row -Reading $reading -Marker ""
        $sinceStart = [math]::Round($reading.Private - $first, 0)
        $colour = "Gray"
        if ($sinceStart -gt 1000) { $colour = "Yellow" }
        if ($sinceStart -gt 3000) { $colour = "Red" }
        Write-Host ("{0}  private {1,8:N0} MB   working set {2,8:N0} MB   ({3:+#;-#;0} MB since start)" -f (Get-Date -Format "HH:mm:ss"), $reading.Private, $reading.WorkingSet, $sinceStart) -ForegroundColor $colour

        # wait for the next reading, answering keys meanwhile
        $until = (Get-Date).AddSeconds($IntervalSeconds)
        $quit = $false
        while ((Get-Date) -lt $until) {
            $key = Read-Key
            if ($key -ne $null) {
                if ($key -eq "q") { $quit = $true; break }
                if ($key -eq "m" -or $key -eq "b") {
                    $reading = Take-Reading
                    if ($key -eq "b") {
                        $label = "baseline"
                    } else {
                        $markerCount++
                        $label = "round {0}" -f $markerCount
                    }
                    $previous = $null
                    if ($markers.Count -gt 0) { $previous = $markers[$markers.Count - 1].Private }
                    $markers += [pscustomobject]@{ Label = $label; Private = $reading.Private; Elapsed = [math]::Round(((Get-Date) - $start).TotalSeconds, 0) }
                    Add-Row -Reading $reading -Marker $label
                    if ($previous -ne $null) {
                        Write-Host ("MARK {0}: private {1:N0} MB ({2:+#;-#;0} MB since the last marker)" -f $label, $reading.Private, ($reading.Private - $previous)) -ForegroundColor Cyan
                    } else {
                        Write-Host ("MARK {0}: private {1:N0} MB" -f $label, $reading.Private) -ForegroundColor Cyan
                    }
                }
            }
            Start-Sleep -Milliseconds 100
        }
        if ($quit) { break }
    }
}
finally {
    Write-Host ""
    if ($markers.Count -gt 0) {
        Write-Host "Markers (private memory, MB):" -ForegroundColor Cyan
        $previous = $null
        $baseline = $markers[0].Private
        foreach ($marker in $markers) {
            $step = ""
            if ($previous -ne $null) { $step = "{0:+#;-#;0}" -f ($marker.Private - $previous) }
            Write-Host ("  {0,-10} {1,9:N0}   step {2,6}   since first marker {3:+#;-#;0}" -f $marker.Label, $marker.Private, $step, ($marker.Private - $baseline))
            $previous = $marker.Private
        }
        Write-Host ""
        Write-Host "If the steps stay near zero after the first round, nothing is leaking. If every round adds about the same, something is."
    }
    Write-Host ("Peak private memory {0:N0} MB. Log: {1}" -f $peak, $csv)
}
