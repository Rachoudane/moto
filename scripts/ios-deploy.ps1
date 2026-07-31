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
    & $Builder ios build
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Build failed (exit $LASTEXITCODE)." -ForegroundColor Red
        exit $LASTEXITCODE
    }
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
