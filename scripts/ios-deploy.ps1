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

function Invoke-Build {
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

function Get-LatestIpa {
    if (-not (Test-Path $DistDir)) {
        Write-Host "No dist/ directory found - run a build first." -ForegroundColor Red
        exit 1
    }
    # Prefer a signed IPA if one exists among the most recent files.
    $signed = Get-ChildItem $DistDir -Filter "*-signed.ipa" -ErrorAction SilentlyContinue |
        Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if ($signed) { return $signed }

    $any = Get-ChildItem $DistDir -Filter "*.ipa" -ErrorAction SilentlyContinue |
        Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if (-not $any) {
        Write-Host "No .ipa file found in $DistDir." -ForegroundColor Red
        exit 1
    }
    return $any
}

function Invoke-Install {
    $ipa = Get-LatestIpa
    Write-Host "==> Installing $($ipa.Name) ($([math]::Round($ipa.Length / 1MB, 1)) MB) via MobAI..." -ForegroundColor Cyan
    & $Builder mobai install $ipa.FullName
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Install failed (exit $LASTEXITCODE). Is MobAI running and the iPhone connected?" -ForegroundColor Red
        exit $LASTEXITCODE
    }
    Write-Host "==> Installed. Open Moto on the iPhone." -ForegroundColor Green
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
