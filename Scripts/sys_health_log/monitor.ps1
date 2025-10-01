[CmdletBinding()]
param(
    # Path to JSON config; if missing or invalid, we use defaults.
    [string]$Config = ".\config.json",
    
    # Folder for logs (will be created if needed).
    [string]$OutDir = ".\logs",

    # Log format: csv (spreadsheet-friendly) or json (line-delimited JSON).
    [ValidateSet("csv","json")]
    [string]$Format = "csv",

    # If -Quiet is set, we still log but we suppress the console summary line.
    [switch]$Quiet
)

# ----------------------------------- Helper: read config -----------------------------------------
function Read-Config {
    param([string]$Path)
    # Return the JSON config object or $null on failure
    if (Test-Path $Path) {
        try {
            Get-Content -Raw -Path $Path | ConvertFrom-Json
        } catch {
            # If JSON is malformed, return null so we fall back to defaults
            $null
        } 
    } else {
        $null
    }
}

# ----------------------------------- Helper: default config values -----------------------------------------
function Default-Config {
    # Create an in-memory object matching the config schema.
    @{
        thresholds = @{
            cpu_warn = 75; cpu_crit = 90
            mem_warn = 75; mem_crit = 90
            disk_free_gb_warn = 10; disk_free_gb_crit = 5
        }
        services = @("Spooler","wuauserv","LanmanServer")
        log = @{ basename = "syshealth"; max_kb = 1024; keep = 7 }
    } | ConvertTo-Json -Depth 5 | ConvertFrom-Json
}

# ----------------------------------- Helper: ensure folder -----------------------------------------
function Ensure-Dir {
    param([string]$p)
    if (-not (Test-Path $p)) {
        New-Item -ItemType Directory -Path $p | Out-Null
    }
}

# ----------------------------------- Helper: build log path -----------------------------------------
function New-LogPath {
    param([string]$dir, [string]$base,[string]$fmt)
    $date = Get-Date -Format "yyyyMMdd"
    Join-Path $dir "$base-$date.$fmt"
}

# ----------------------------------- Helper: rotate logs -----------------------------------------