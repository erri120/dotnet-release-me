$loc = Get-Location
Write-Host $loc

Write-Host $env:SignExecutable
Write-Host $env:BUILD_APP_BIN
Write-Host $env:APP_BASE_NAME

$searchDirectory = $args[0];
if ($searchDirectory) {
    Write-Host "Using search directory $searchDirectory"
    Get-ChildItem -Path $searchDirectory | ForEach-Object -Process { Write-Host $_.FullName }
    $executableToSign = Get-ChildItem -Path $searchDirectory | Where-Object { $_.Extension -eq ".exe" } | Select-Object -First 1
} else {
    $executableToSign = [System.IO.Path]::Combine($env:BUILD_APP_BIN, $env:APP_BASE_NAME + ".exe")
}

Write-Host $executableToSign

if (Test-Path $executableToSign -PathType Leaf) {
    Write-Host "Signing $executableToSign";
} else {
    Write-Error "File $executableToSign doesn't exist!";
    exit 1;
}


# https://github.com/actions/runner-images/blob/main/images/win/Windows2022-Readme.md#installed-windows-sdks
#$rootDirectory = "C:\Program Files (x86)\Windows Kits\";
#Get-ChildItem -Path $rootDirectory -Recurse | Where-Object { $_.Name -icontains "signtool.exe" } | ForEach-Object -Process { Write-Host $_.FullName }
#$signToolPath = Get-ChildItem -Path $rootDirectory -Recurse | Where-Object { $_.Name -icontains "signtool.exe" -and $_.Parent.Name -eq "x64" } | Select-Object -Last 1

$signToolPath = "C:\Program Files (x86)\Windows Kits\10\bin\10.0.22621.0\x64\signtool.exe"
if (Test-Path $signToolPath -PathType Leaf) {
    Write-Host "Found signtool.exe at: $signToolPath";
} else {
    Write-Error "Singing tool at $signToolPath doesn't exist!";
    exit 1;
}

Write-Host "Signing $executableToSign";

& $signToolPath sign /f "$env:SigningCertificate" /p "$env:SigningCertificatePassword" /td sha256 /fd sha256 /tr "$env:TimestampServer" $executableToSign
$exitCode = $LASTEXITCODE

if ($exitCode -eq 0) {
    Write-Host "Signing completed"
} else {
    Write-Error "Signing failed with code $exitCode"
    exit $exitCode
}
