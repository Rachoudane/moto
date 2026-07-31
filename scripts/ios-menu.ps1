<#
.SYNOPSIS
  Interactive menu for the Moto iOS build/install loop (Windows, no Mac).

.DESCRIPTION
  Wraps builder-windows-amd64.exe + MobAI so day-to-day iOS testing is a single
  numbered choice instead of remembering flags and doing the manual Ctrl+C
  timing trick. Run it and pick a number.

.EXAMPLE
  .\scripts\ios-menu.ps1
#>

$ErrorActionPreference = "Stop"
$RepoRoot = Split-Path -Parent $PSScriptRoot
$Builder = Join-Path $RepoRoot "builder-windows-amd64.exe"
$DistDir = Join-Path $RepoRoot "dist"

# builder.exe resolves builder.json relative to its working directory, not its
# own exe path — force it to the repo root regardless of where this script
# was launched from (e.g. after `cd scripts`).
Set-Location $RepoRoot

function Assert-Builder {
    if (-not (Test-Path $Builder)) {
        Write-Host "builder-windows-amd64.exe not found at $Builder" -ForegroundColor Red
        exit 1
    }
}

function Get-LatestIpa {
    if (-not (Test-Path $DistDir)) { return $null }
    $signed = Get-ChildItem $DistDir -Filter "*-signed.ipa" -ErrorAction SilentlyContinue |
        Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if ($signed) { return $signed }
    return (Get-ChildItem $DistDir -Filter "*.ipa" -ErrorAction SilentlyContinue |
        Sort-Object LastWriteTime -Descending | Select-Object -First 1)
}

function Invoke-Build {
    Write-Host "`n==> Triggering iOS build on GitHub Actions (this takes a few minutes)..." -ForegroundColor Cyan
    # `| Out-Host` is required: an uncaptured native command's stdout lines get
    # smuggled into this function's own return value alongside $true/$false.
    # Without it, "if (-not (Invoke-Build))" tests the truthiness of the whole
    # [output-lines..., $false] array, which is always truthy even on failure.
    & $Builder ios build | Out-Host
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Build failed (exit $LASTEXITCODE)." -ForegroundColor Red
        return $false
    }
    return $true
}

function Invoke-Ping {
    Write-Host "`n==> Checking MobAI connectivity..." -ForegroundColor Cyan
    & $Builder mobai ping
}

function Invoke-InstallLatest {
    $ipa = Get-LatestIpa
    if (-not $ipa) {
        Write-Host "No .ipa found in dist/ - build first (option 1 or 3)." -ForegroundColor Red
        return
    }
    Write-Host "`n==> Installing $($ipa.Name) ($([math]::Round($ipa.Length / 1MB, 1)) MB) via MobAI..." -ForegroundColor Cyan
    & $Builder mobai install $ipa.FullName
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Install failed (exit $LASTEXITCODE). Is MobAI running and the iPhone connected?" -ForegroundColor Red
        return
    }
    Write-Host "==> Installed. Open Moto on the iPhone." -ForegroundColor Green
}

# Runs `builder dev flutter` (the only path today that produces a signed IPA),
# watches its live output for the "Installed:" line, then kills the process
# automatically instead of requiring a manually-timed Ctrl+C. The hot-reload
# session it would move on to next crashes on Windows anyway (`which` is a
# Unix command), so cutting it off here is the desired behavior, not a hack.
#
# --ipa is passed explicitly (instead of letting dev flutter auto-detect)
# because auto-detect falls back to an interactive arrow-key picker whenever
# dist/ has more than one matching IPA (e.g. an old -signed.ipa left over
# from a previous run). That picker needs a real console; under redirected
# stdio it just hangs until the 5-minute timeout kills it.
function Invoke-QuickTestInstall {
    Write-Host "`n==> Step 1/2: Building..." -ForegroundColor Cyan
    if (-not (Invoke-Build)) { return }

    $freshIpa = Get-ChildItem $DistDir -Filter "*.ipa" -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -notmatch "-signed\.ipa$" } |
        Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if (-not $freshIpa) {
        Write-Host "Build succeeded but no unsigned .ipa showed up in dist/." -ForegroundColor Red
        return
    }

    Write-Host "`n==> Step 2/2: Signing + installing $($freshIpa.Name) via MobAI (auto-stops once installed)..." -ForegroundColor Cyan

    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = $Builder
    $psi.Arguments = 'dev flutter --ipa "' + $freshIpa.FullName + '"'
    $psi.WorkingDirectory = $RepoRoot
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    $psi.UseShellExecute = $false
    $psi.CreateNoWindow = $true

    $proc = New-Object System.Diagnostics.Process
    $proc.StartInfo = $psi

    $Global:__motoInstalled = $false
    # Register-ObjectEvent injects $EventArgs into this scriptblock's scope
    # automatically; no param block needed (and declaring one would shadow
    # the built-in $Sender variable).
    $printAndWatch = {
        if ($null -ne $EventArgs.Data) {
            Write-Host $EventArgs.Data
            if ($EventArgs.Data -match "Installed:") { $Global:__motoInstalled = $true }
        }
    }
    Register-ObjectEvent -InputObject $proc -EventName OutputDataReceived -Action $printAndWatch | Out-Null
    Register-ObjectEvent -InputObject $proc -EventName ErrorDataReceived -Action $printAndWatch | Out-Null

    $proc.Start() | Out-Null
    $proc.BeginOutputReadLine()
    $proc.BeginErrorReadLine()

    $sw = [Diagnostics.Stopwatch]::StartNew()
    while (-not $proc.HasExited -and -not $Global:__motoInstalled -and $sw.Elapsed.TotalSeconds -lt 300) {
        Start-Sleep -Milliseconds 300
    }

    if ($Global:__motoInstalled) {
        Start-Sleep -Milliseconds 600  # let the "Installed:" line fully flush
        if (-not $proc.HasExited) {
            Write-Host "`n==> Install confirmed - stopping the hot-reload session automatically." -ForegroundColor Yellow
            Stop-Process -Id $proc.Id -Force -ErrorAction SilentlyContinue
        }
    } elseif (-not $proc.HasExited) {
        Write-Host "`n==> Timed out after 5 minutes - stopping the session." -ForegroundColor Red
        Stop-Process -Id $proc.Id -Force -ErrorAction SilentlyContinue
    }
    Get-EventSubscriber | Where-Object { $_.SourceObject -eq $proc } | Unregister-Event -ErrorAction SilentlyContinue

    if ($Global:__motoInstalled) {
        Write-Host "`n==> Moto is installed on the iPhone. Open it from the home screen." -ForegroundColor Green
    } else {
        Write-Host "`n==> Didn't see a successful install within 5 minutes - check MobAI is open and the iPhone is connected." -ForegroundColor Red
    }
}

function Show-SubmissionInfo {
    Write-Host @"

App Store submission builds don't go through MobAI - Apple blocks sideloading
of App Store-signed IPAs. The flow for a build you can both submit AND test:

  1. Push your commit to GitHub as usual.
  2. Codemagic (not set up yet) builds + signs with a Distribution certificate
     and uploads straight to App Store Connect.
  3. In App Store Connect, add yourself as an internal TestFlight tester.
  4. Install the exact same build via the TestFlight app on your iPhone -
     this is the real submission candidate, not a separate dev build.

This is a one-time Codemagic setup we haven't done yet. Ask me when you're
ready to wire it up.
"@ -ForegroundColor White
}

Assert-Builder

while ($true) {
    Write-Host "`n========================================" -ForegroundColor DarkGray
    Write-Host " Moto iOS - build/test menu" -ForegroundColor White
    Write-Host "========================================" -ForegroundColor DarkGray
    Write-Host " 1) Quick test: build + sign + auto-install (recommended)"
    Write-Host " 2) Build only (no install)"
    Write-Host " 3) Install latest IPA from dist/ (no rebuild)"
    Write-Host " 4) Check MobAI / iPhone connectivity"
    Write-Host " 5) About App Store submission builds (info only)"
    Write-Host " 0) Exit"
    $choice = Read-Host "`nChoice"

    switch ($choice) {
        "1" { Invoke-QuickTestInstall }
        "2" { Invoke-Build | Out-Null }
        "3" { Invoke-InstallLatest }
        "4" { Invoke-Ping }
        "5" { Show-SubmissionInfo }
        "0" { Write-Host "Bye."; exit 0 }
        default { Write-Host "Not a valid option." -ForegroundColor Yellow }
    }
}
