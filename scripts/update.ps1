$ErrorActionPreference = 'Stop'

$metadataUrl = 'https://prod.download.desktop.kiro.dev/stable/metadata-win32-x64-user-stable.json'
$metadata = Invoke-RestMethod -Uri $metadataUrl

$version = $metadata.currentRelease
if ([string]::IsNullOrWhiteSpace($version)) {
  throw 'Current release lookup returned an empty value.'
}

$release = $metadata.releases | Where-Object { $_.version -eq $version } | Select-Object -First 1
if (-not $release) {
  $release = $metadata.releases | Select-Object -First 1
}
if (-not $release -or -not $release.updateTo -or [string]::IsNullOrWhiteSpace($release.updateTo.url)) {
  throw "Release metadata missing download URL for $version."
}

$downloadUrl = $release.updateTo.url

$repoRoot = Split-Path -Parent $PSScriptRoot
$nuspec = Get-ChildItem -Path $repoRoot -Filter 'kiro*.nuspec' | Select-Object -First 1
if (-not $nuspec) {
  throw 'Could not find a kiro nuspec file.'
}

$nuspecContent = Get-Content -Path $nuspec.FullName -Raw
$currentVersionMatch = [regex]::Match($nuspecContent, '<version>([^<]+)</version>')
$currentVersion = if ($currentVersionMatch.Success) { $currentVersionMatch.Groups[1].Value } else { '' }

$expectedNuspecName = "kiro.$version.nuspec"
if ($currentVersion -eq $version -and $nuspec.Name -eq $expectedNuspecName) {
  $installPath = Join-Path $repoRoot 'tools\chocolateyinstall.ps1'
  $installContent = Get-Content -Path $installPath -Raw
  $hasDownloadUrl = $installContent -match [regex]::Escape($downloadUrl)
  if ($hasDownloadUrl) {
    Write-Host "Kiro is already at $version. No update needed."
    return
  }
}

$tempFile = Join-Path $env:TEMP "Kiro-$version.exe"
Invoke-WebRequest -Uri $downloadUrl -OutFile $tempFile
$checksum = (Get-FileHash $tempFile -Algorithm SHA256).Hash
Remove-Item $tempFile

$updatedNuspec = [regex]::Replace(
  $nuspecContent,
  '<version>[^<]+</version>',
  "<version>$version</version>"
)
if ($updatedNuspec -ne $nuspecContent) {
  Set-Content -Path $nuspec.FullName -Value $updatedNuspec -Encoding utf8
}

if ($nuspec.Name -ne $expectedNuspecName) {
  Rename-Item -Path $nuspec.FullName -NewName $expectedNuspecName
}

$installPath = Join-Path $repoRoot 'tools\chocolateyinstall.ps1'
$installContent = Get-Content -Path $installPath -Raw
$installContent = [regex]::Replace(
  $installContent,
  'https://prod.download.desktop.kiro.dev/[^''\"]+\.exe',
  $downloadUrl
)
$installContent = [regex]::Replace(
  $installContent,
  "checksum\s+=\s+'[^']+'",
  "checksum      = '$checksum'"
)
Set-Content -Path $installPath -Value $installContent -Encoding utf8

$checksumPath = Join-Path $repoRoot 'get_checksum.ps1'
$checksumContent = @"
`$url = '$downloadUrl'
`$f = "`$env:TEMP\Kiro.exe"
Invoke-WebRequest -Uri `$url -OutFile `$f
(Get-FileHash `$f -Algorithm SHA256).Hash
Remove-Item `$f
"@
Set-Content -Path $checksumPath -Value $checksumContent -Encoding utf8

Write-Host "Updated to Kiro $version"
