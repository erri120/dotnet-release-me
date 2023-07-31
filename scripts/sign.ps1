Write-Host $env:BUILD_APP_BIN
Write-Host $env:APP_BASE_NAME

$executableToSign = $env:BUILD_APP_BIN

#$executableToSign = $args[0]

#if ($null -eq $executableToSign) {
#    Write-Error "Missing first argument!";
#    exit 1;
#}

# https://github.com/actions/runner-images/blob/main/images/win/Windows2022-Readme.md#installed-windows-sdks
$rootDirectory = "C:\Program Files (x86)\Windows Kits\bin\";

Get-ChildItem -Path $rootDirectory -Recurse | Where-Object { $_.Name -icontains "signtool.exe" } | ForEach-Object -Process { Write-Host $_.FullName }

$signToolPath = Get-ChildItem -Path $rootDirectory -Recurse | Where-Object { $_.Name -icontains "signtool.exe" -and $_.Parent.Name -eq "x64" } | Select-Object -Last 1

if ($null -eq $signToolPath) {
    Write-Error "signtool.exe not found!"
    exit 1;
}

$signToolPath = $signToolPath.FullName
Write-Host "Found signtool.exe at: $signToolPath"

Write-Host "Signing $executableToSign"

& $signToolPath sign /f "$env:SigningCertificate" /p "$env:SigningCertificatePassword" /td sha256 /fd sha256 /tr "$env:TimestampServer" $executableToSign
$exitCode = $LASTEXITCODE

if ($exitCode -eq 0) {
    Write-Host "Signing completed"
} else {
    Write-Error "Signing failed with code $exitCode"
    exit $exitCode
}
