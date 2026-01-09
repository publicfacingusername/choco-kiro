$url = 'https://prod.download.desktop.kiro.dev/releases/202508020313-Kiro-win32-x64.exe'
$f = "$env:TEMP\Kiro.exe"
Invoke-WebRequest -Uri $url -OutFile $f
(Get-FileHash $f -Algorithm SHA256).Hash
Remove-Item $f
