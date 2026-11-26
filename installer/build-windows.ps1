# Builds the Windows release packages into dist\:
#   Santaroni-<version>-windows-setup.exe   (installer)
#   Santaroni-<version>-windows-portable.zip (unzip and run santaroni.exe)
# The version comes from pubspec.yaml. Needs Flutter and Inno Setup 6.
#
# Usage, from the repository root:  pwsh installer\build-windows.ps1

$ErrorActionPreference = 'Stop'
Set-Location (Join-Path $PSScriptRoot '..')

$line = Select-String -Path pubspec.yaml -Pattern '^version:\s*([0-9.]+)' | Select-Object -First 1
if (-not $line) { throw 'No version in pubspec.yaml' }
$version = $line.Matches[0].Groups[1].Value
Write-Host "Santaroni $version"

flutter build windows --release
if ($LASTEXITCODE -ne 0) { throw 'flutter build failed' }

$release = 'build\windows\x64\runner\Release'
New-Item -ItemType Directory -Force dist | Out-Null

# Portable zip: the app folder, minus debug symbols, inside a "Santaroni" folder.
$staging = Join-Path ([IO.Path]::GetTempPath()) "santaroni-$version"
Remove-Item -Recurse -Force $staging -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force "$staging\Santaroni" | Out-Null
Copy-Item -Recurse "$release\*" "$staging\Santaroni" -Exclude '*.pdb'
$zip = "dist\Santaroni-$version-windows-portable.zip"
Remove-Item -Force $zip -ErrorAction SilentlyContinue
Compress-Archive -Path "$staging\Santaroni" -DestinationPath $zip
Remove-Item -Recurse -Force $staging

# Installer.
$iscc = (Get-Command iscc -ErrorAction SilentlyContinue).Source
if (-not $iscc) {
  $iscc = @(
    "${env:ProgramFiles(x86)}\Inno Setup 6\ISCC.exe",
    "$env:ProgramFiles\Inno Setup 6\ISCC.exe",
    "$env:LOCALAPPDATA\Programs\Inno Setup 6\ISCC.exe"
  ) | Where-Object { Test-Path $_ } | Select-Object -First 1
}
if (-not $iscc) { throw 'Inno Setup 6 not found (ISCC.exe). Install it from https://jrsoftware.org/isdl.php' }
& $iscc /Qp "/DAppVersion=$version" installer\santaroni.iss
if ($LASTEXITCODE -ne 0) { throw 'Inno Setup failed' }

Get-ChildItem dist | Format-Table Name, @{ n = 'MB'; e = { [math]::Round($_.Length / 1MB, 1) } }
