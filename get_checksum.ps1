$url = 'https://prod.download.desktop.kiro.dev/releases/stable/win32-x64/signed/1.0.212/kiro-ide-1.0.212-stable-win32-x64.exe'
$f = "$env:TEMP\Kiro.exe"
Invoke-WebRequest -Uri $url -OutFile $f
(Get-FileHash $f -Algorithm SHA256).Hash
Remove-Item $f
