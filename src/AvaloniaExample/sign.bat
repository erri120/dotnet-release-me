echo %~f0%

set "scriptPath=..\..\sign.ps1"

powershell.exe -ExecutionPolicy Bypass -File "%scriptPath%"
