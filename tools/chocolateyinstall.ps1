$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://prod.download.desktop.kiro.dev/releases/stable/win32-x64/signed/1.0.309/kiro-ide-1.0.309-stable-win32-x64.exe'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'exe'
  url           = $url
  softwareName  = 'Kiro*'
  checksum      = 'FCC07E63BDFE1A0B477D283ED72704615FADF52E13DCAEB8AF7C35A2D9D41E86'
  checksumType  = 'sha256'
  silentArgs    = "/VERYSILENT"
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs # https://docs.chocolatey.org/en-us/create/functions/install-chocolateypackage











































