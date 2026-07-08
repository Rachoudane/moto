# build_release.ps1
# Usage: .\build_release.ps1
# Increments minor version (1.2.0 -> 1.3.0) and versionCode (+1) then builds the AAB.

$file = "pubspec.yaml"
$content = Get-Content $file -Raw

if ($content -notmatch 'version:\s+(\d+)\.(\d+)\.(\d+)\+(\d+)') {
    Write-Error "Could not parse version from pubspec.yaml"
    exit 1
}

$major = [int]$Matches[1]
$minor = [int]$Matches[2]
$patch = [int]$Matches[3]
$code  = [int]$Matches[4]

$oldVersion = "$major.$minor.$patch+$code"

if ($patch -lt 9) {
    $newVersion = "$major.$minor.$($patch + 1)+$($code + 1)"
} elseif ($minor -lt 9) {
    $newVersion = "$major.$($minor + 1).0+$($code + 1)"
} else {
    $newVersion = "$($major + 1).0.0+$($code + 1)"
}

$content = $content -replace [regex]::Escape("version: $oldVersion"), "version: $newVersion"

# Write UTF-8 without BOM so Flutter's yaml parser is happy
[System.IO.File]::WriteAllText(
    (Resolve-Path $file).Path,
    $content,
    [System.Text.UTF8Encoding]::new($false)
)

Write-Host "Version bumped: $oldVersion -> $newVersion"
flutter build appbundle --release
