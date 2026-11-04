# Dot-source before Flutter/Dart commands when the Windows SDK path contains spaces.
# Only creates task-owned SDK helpers under TEMP; never moves/edits the original SDK.
[CmdletBinding()]
param([string]$FlutterSdk)
$nativePreviousErrorPreference = $ErrorActionPreference
$ErrorActionPreference = 'Stop'
if (-not $FlutterSdk) {
  $FlutterSdk = Split-Path (Split-Path (Get-Command flutter).Source -Parent) -Parent
}
$sourceFlutter = [System.IO.Path]::GetFullPath($FlutterSdk)
$sourceItem = Get-Item -LiteralPath $sourceFlutter
if ($sourceItem.LinkType -eq 'Junction') { $sourceFlutter = $sourceItem.Target[0] }
$sourceDart = Join-Path $sourceFlutter 'bin/cache/dart-sdk'
if (-not (Test-Path -LiteralPath (Join-Path $sourceDart 'bin/dart.exe'))) {
  throw 'Flutter SDK with bundled Dart was not found.'
}
$nativeTempRoot = [System.IO.Path]::GetFullPath($env:TEMP)
if ($nativeTempRoot.Contains(' ')) { throw 'TEMP must have a path without spaces.' }
$nativeDart = Join-Path $nativeTempRoot 'laurum-native-dart-sdk'
$nativeFlutter = Join-Path $nativeTempRoot 'laurum-flutter-sdk'
if (-not (Test-Path -LiteralPath $nativeFlutter)) {
  New-Item -ItemType Junction -Path $nativeFlutter -Target $sourceFlutter | Out-Null
} else {
  $aliasItem = Get-Item -LiteralPath $nativeFlutter
  if ($aliasItem.LinkType -ne 'Junction' -or $aliasItem.Target[0] -ne $sourceFlutter) {
    throw 'Existing TEMP Flutter alias has an unexpected target; it was left untouched.'
  }
}
$revision = Join-Path $sourceDart 'revision'
$cachedRevision = Join-Path $nativeDart '.laurum-copy-revision'
$copyNeeded = -not (Test-Path -LiteralPath (Join-Path $nativeDart 'bin/dart.exe'))
if (-not $copyNeeded) {
  $copyNeeded = -not (Test-Path -LiteralPath $cachedRevision) -or
    [System.IO.File]::ReadAllText($cachedRevision) -ne [System.IO.File]::ReadAllText($revision)
}
if ($copyNeeded) {
  # /E copies only; no mirror, purge, delete, or changes to the source SDK.
  & robocopy $sourceDart $nativeDart /E /XJ /R:1 /W:1 /NFL /NDL /NJH /NJS /NP
  if ($LASTEXITCODE -ge 8) { throw 'Copying the task-local Dart SDK failed.' }
  [System.IO.File]::WriteAllText($cachedRevision, [System.IO.File]::ReadAllText($revision))
}
$env:PATH = "$nativeDart\bin;$nativeFlutter\bin;$env:PATH"
$env:FLUTTER_ROOT = $nativeFlutter
$global:LASTEXITCODE = 0
Write-Output 'Native SDK helpers active for this PowerShell process only.'
$ErrorActionPreference = $nativePreviousErrorPreference
