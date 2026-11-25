$url = 'https://prod.download.desktop.kiro.dev/releases/stable/win32-x64/signed/1.5.37/kiro-ide-1.5.37-stable-win32-x64.exe'
$f = "$env:TEMP\Kiro.exe"
Invoke-WebRequest -Uri $url -OutFile $f
(Get-FileHash $f -Algorithm SHA256).Hash
Remove-Item $f
