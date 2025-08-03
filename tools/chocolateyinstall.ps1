$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://prod.download.desktop.kiro.dev/releases/202508020313-Kiro-win32-x64.exe'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'exe'
  url           = $url
  softwareName  = 'Kiro*'
  checksum      = 'C8C5F4A4817F7823BC6B3287C406EB7DA3347922F4139AC477406EB50E6FDE36'
  checksumType  = 'sha256'
  silentArgs    = "/VERYSILENT"
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs # https://docs.chocolatey.org/en-us/create/functions/install-chocolateypackage
