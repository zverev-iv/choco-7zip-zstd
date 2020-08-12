$ErrorActionPreference = 'Stop';

$meta = Get-Content -Path $env:ChocolateyPackageFolder\tools\packageArgs.json -Raw
$packageArgs = @{}
(ConvertFrom-Json $meta).psobject.properties | ForEach-Object { $packageArgs[$_.Name] = $_.Value }

$filename = if ((Get-OSArchitectureWidth 64) -and $env:chocolateyForceX86 -ne $true) {
       Split-Path $packageArgs["url64bit"] -Leaf }
else { Split-Path $packageArgs["url"] -Leaf }

$packageArgs["packageName"] = "$($env:ChocolateyPackageName)"
$packageArgs["fileFullPath"] = "$(Join-Path (Split-Path -parent $MyInvocation.MyCommand.Definition) $filename)"

$archiveLocation = Get-ChocolateyWebFile @packageArgs 
$extractLocation = "$(Join-Path (Split-Path -parent $archiveLocation) "Codecs")"
$spliter = "path to executable:"
$7zLocation = "$(Split-Path -parent ((7z --shimgen-noop | Select-String $spliter) -split $spliter | ForEach-Object Trim)[1])"

Write-Host "Extract files" -ForegroundColor Blue
if ((Get-OSArchitectureWidth 64) -and $env:chocolateyForceX86 -ne $true) {
       7z e "$($archiveLocation)"  -o"$($extractLocation)"  *-x64.dll -y -r }
else {
       7z e "$($archiveLocation)"  -o"$($extractLocation)"  *-x32.dll -y -r }
Copy-Item "$($extractLocation)" "$($7zLocation)" -Force -Recurse -Verbose
Write-Host "Extraction completed" -ForegroundColor Blue