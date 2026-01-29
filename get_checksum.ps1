$url = 'https://prod.download.desktop.kiro.dev/releases/stable/win32-x64/signed/0.8.206/kiro-ide-0.8.206-stable-win32-x64.exe'
$f = "$env:TEMP\Kiro.exe"
Invoke-WebRequest -Uri $url -OutFile $f
(Get-FileHash $f -Algorithm SHA256).Hash
Remove-Item $f
