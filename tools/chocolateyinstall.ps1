$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://prod.download.desktop.kiro.dev/releases/stable/win32-x64/signed/0.9.2/kiro-ide-0.9.2-stable-win32-x64.exe'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'exe'
  url           = $url
  softwareName  = 'Kiro*'
  checksum      = '911BE1E758C00FB3C87AD90B2510453C7361E749504933F14119AD8E5015D6F2'
  checksumType  = 'sha256'
  silentArgs    = "/VERYSILENT"
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs # https://docs.chocolatey.org/en-us/create/functions/install-chocolateypackage






