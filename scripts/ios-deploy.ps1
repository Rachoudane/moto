<#
.SYNOPSIS
  Wraps builder-windows-amd64.exe for a one-command iOS build + install flow.

.DESCRIPTION
  Once code signing is configured via `builder signing setup`, `builder ios build`
  produces an already-signed IPA - no need for the `builder dev flutter` + Ctrl+C
  workaround. This script just chains build -> pick latest IPA -> mobai install,
  using absolute paths (mobai install fails silently on relative paths).

.PARAMETER Action
  build   - trigger a remote iOS build only
  install - install the most recent IPA in dist/ onto the connected iPhone
  deploy  - build, then install the result (default)
  ping    - check MobAI connectivity to the iPhone

.EXAMPLE
  .\scripts\ios-deploy.ps1
  .\scripts\ios-deploy.ps1 -Action build
  .\scripts\ios-deploy.ps1 -Action install
#>

param(
    [ValidateSet("build", "install", "deploy", "ping")]
    [string]$Action = "deploy"
)

$ErrorActionPreference = "Stop"
$RepoRoot = Split-Path -Parent $PSScriptRoot
$Builder = Join-Path $RepoRoot "builder-windows-amd64.exe"
$DistDir = Join-Path $RepoRoot "dist"

# builder.exe resolves builder.json relative to its working directory, not its
# own exe path — force it to the repo root regardless of where this script
# was launched from.
Set-Location $RepoRoot

function Assert-Builder {
    if (-not (Test-Path $Builder)) {
        Write-Host "builder-windows-amd64.exe not found at $Builder" -ForegroundColor Red
        exit 1
    }
}

# Removes every .ipa from dist/ (signed and unsigned) before a new build.
# Without this, Get-LatestIpa's preference for *-signed.ipa over plain .ipa
# can silently pick a STALE signed file left over from a previous
# build/install (e.g. from Resolve-BuildFromGitHub, which downloads an
# unsigned artifact and never produces a same-run -signed.ipa) even though a
# newer, correct .ipa exists - reinstalling old code with no error or warning.
function Clear-DistIpas {
    if (Test-Path $DistDir) {
        Get-ChildItem $DistDir -Filter "*.ipa" -ErrorAction SilentlyContinue | Remove-Item -Force
    }
}

function Invoke-Build {
    Clear-DistIpas
    Write-Host "==> Triggering iOS build on GitHub Actions..." -ForegroundColor Cyan
    # NOTE: deliberately NOT redirecting stderr (no `2>&1`) - under
    # $ErrorActionPreference = "Stop", merging a native command's stderr into
    # the pipeline turns every stderr line into a terminating NativeCommandError,
    # which would abort this script before the fallback below ever runs.
    & $Builder ios build
    if ($LASTEXITCODE -ne 0) {
        # builder.exe has its own ~2min poll waiting for the GitHub Actions run
        # to become visible via the API before it gives up. That poll has been
        # observed to time out even though the run did start and went on to
        # finish successfully a few minutes later - a false negative, not a
        # real build failure. Always check GitHub directly before giving up
        # (harmless if this really was a different failure - it just won't
        # find a matching successful run).
        Write-Host "==> builder.exe reported failure - checking GitHub Actions directly in case this is the known false negative..." -ForegroundColor Yellow
        if (Resolve-BuildFromGitHub) { return }
        Write-Host "Build failed (exit $LASTEXITCODE)." -ForegroundColor Red
        exit $LASTEXITCODE
    }
}

# Fallback for the false negative described above: polls GitHub Actions
# directly for the run that was actually triggered, waits for it to finish,
# and downloads the IPA artifact into dist/ (flattened out of the dist/ipa/
# subfolder `gh run download` creates) so the rest of the script picks it up
# exactly like a normal build. Requires the `gh` CLI to be installed/authed.
function Resolve-BuildFromGitHub {
    if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
        Write-Host "==> gh CLI not found - can't auto-recover. Check https://github.com/Rachoudane/moto/actions manually." -ForegroundColor Red
        return $false
    }

    Write-Host "==> Waiting for the most recent 'iOS Build' run to finish (up to 5 min)..." -ForegroundColor Cyan
    $sw = [Diagnostics.Stopwatch]::StartNew()
    while ($sw.Elapsed.TotalSeconds -lt 300) {
        $runs = gh run list --workflow=ios-build.yml --limit 1 --json databaseId,status,conclusion,createdAt 2>$null | ConvertFrom-Json
        if ($runs -and $runs.Count -gt 0) {
            $run = $runs[0]
            $ageMinutes = ((Get-Date).ToUniversalTime() - [datetime]$run.createdAt).TotalMinutes
            if ($ageMinutes -lt 10) {
                if ($run.status -eq "completed") {
                    if ($run.conclusion -eq "success") {
                        Write-Host "==> Run $($run.databaseId) completed successfully on GitHub - downloading the IPA artifact..." -ForegroundColor Green
                        gh run download $run.databaseId --dir $DistDir | Out-Null
                        $ipaSubDir = Join-Path $DistDir "ipa"
                        if (Test-Path $ipaSubDir) {
                            Get-ChildItem $ipaSubDir -Filter "*.ipa" | ForEach-Object {
                                Move-Item $_.FullName (Join-Path $DistDir $_.Name) -Force
                            }
                            Remove-Item $ipaSubDir -Recurse -Force -ErrorAction SilentlyContinue
                        }
                        return $true
                    } else {
                        Write-Host "==> Run $($run.databaseId) finished with conclusion '$($run.conclusion)' - that's a real failure, not a false negative." -ForegroundColor Red
                        return $false
                    }
                }
            }
        }
        Start-Sleep -Seconds 10
    }
    Write-Host "==> No matching run finished within 5 minutes - giving up on auto-recovery." -ForegroundColor Red
    return $false
}

# `builder mobai install` (plain) requires an ALREADY-signed IPA - tested
# directly against an unsigned build and it fails with
# "ApplicationVerificationFailed ... No code signature found". Since nothing
# in this repo runs `builder signing setup` (no local signing profile
# configured - MobAI's ad-hoc resign is what actually signs), `builder ios
# build` never produces a pre-signed IPA either. `builder dev flutter --ipa`
# is the only CLI path today that both signs and installs - it starts a
# Flutter hot-reload session as a side effect, so we watch its output for
# "Installed:" and kill it immediately after (the hot-reload session it would
# move on to next crashes on Windows anyway - `which` is a Unix command - so
# cutting it off here is the desired behavior, not a hack). Ported from
# ios-menu.ps1's Invoke-QuickTestInstall, which is the one path proven to
# work end-to-end for both Wingman and Moto.
function Invoke-Install {
    # --ipa is passed explicitly (instead of letting dev flutter auto-detect)
    # because auto-detect falls back to an interactive arrow-key picker
    # whenever dist/ has more than one matching IPA. That picker needs a real
    # console; under redirected stdio it just hangs until a timeout kills it.
    #
    # KNOWN LIMITATION: on the first install of a given IPA (one MobAI hasn't
    # seen/signed before for this device), `dev flutter --ipa` also shows an
    # arrow-key "Resign app: Yes/No" confirmation - same problem, no CLI flag
    # found to skip it (checked --help and the binary's string table). This
    # only bites when this script is driven non-interactively (e.g. by an
    # agent/CI, not a human at a real terminal) - in that case it fails fast
    # with "Error: ^D" rather than hanging. If that happens, sign+install
    # directly via MobAI's MCP tool (`install_app`, `resign: true`) instead
    # of this script, or run this script yourself in a real terminal where
    # you can answer the prompt.
    $freshIpa = Get-ChildItem $DistDir -Filter "*.ipa" -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -notmatch "-signed\.ipa$" } |
        Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if (-not $freshIpa) {
        Write-Host "No unsigned .ipa found in $DistDir - run a build first." -ForegroundColor Red
        exit 1
    }

    Write-Host "==> Signing + installing $($freshIpa.Name) via MobAI (auto-stops once installed)..." -ForegroundColor Cyan

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
            Write-Host "==> Install confirmed - stopping the hot-reload session automatically." -ForegroundColor Yellow
            Stop-Process -Id $proc.Id -Force -ErrorAction SilentlyContinue
        }
    } elseif (-not $proc.HasExited) {
        Write-Host "==> Timed out after 5 minutes - stopping the session." -ForegroundColor Red
        Stop-Process -Id $proc.Id -Force -ErrorAction SilentlyContinue
    }
    Get-EventSubscriber | Where-Object { $_.SourceObject -eq $proc } | Unregister-Event -ErrorAction SilentlyContinue

    if ($Global:__motoInstalled) {
        Write-Host "==> Installed. Open Moto on the iPhone." -ForegroundColor Green
    } else {
        Write-Host "==> Didn't see a successful install within 5 minutes - check MobAI is open and the iPhone is connected." -ForegroundColor Red
        exit 1
    }
}

function Invoke-Ping {
    & $Builder mobai ping
}

Assert-Builder

switch ($Action) {
    "build"   { Invoke-Build }
    "install" { Invoke-Install }
    "deploy"  { Invoke-Build; Invoke-Install }
    "ping"    { Invoke-Ping }
}
