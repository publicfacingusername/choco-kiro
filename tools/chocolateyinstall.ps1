$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://prod.download.desktop.kiro.dev/releases/stable/win32-x64/signed/0.9.47/kiro-ide-0.9.47-stable-win32-x64.exe'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'exe'
  url           = $url
  softwareName  = 'Kiro*'
  checksum      = 'B6952246FCEA5F766A4B5AD4BFC6B505CE57E4B9EFCF116998F13A8B42FF1D71'
  checksumType  = 'sha256'
  silentArgs    = "/VERYSILENT"
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs # https://docs.chocolatey.org/en-us/create/functions/install-chocolateypackage








