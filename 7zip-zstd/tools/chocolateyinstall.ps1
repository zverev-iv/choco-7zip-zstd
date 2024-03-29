﻿$ErrorActionPreference = 'Stop';

$path = Get-ChocolateyPath -PathType 'PackagePath'
$meta = Get-Content -Path $path\tools\packageArgs.ps1 -Raw | Out-String
$packageArgs = (Invoke-Expression $meta)

$filename = if ((Get-OSArchitectureWidth 64) -and $env:chocolateyForceX86 -ne $true) {
       Split-Path $packageArgs["url64bit"] -Leaf }
else { Split-Path $packageArgs["url"] -Leaf }

$packageArgs["packageName"] = "$($env:ChocolateyPackageName)"
$packageArgs["fileFullPath"] = "$(Join-Path (Split-Path -parent $MyInvocation.MyCommand.Definition) $filename)"

$archiveLocation = Get-ChocolateyWebFile @packageArgs
$extractLocation = "$(Join-Path (Split-Path -parent $archiveLocation) "Codecs")"

$spliter = "path to executable:"
$7zLocation = "$(Split-Path -parent ((7z --shimgen-noop | Select-String $spliter) -split $spliter | ForEach-Object Trim)[1])"
$installLocation = "$(Join-Path $7zLocation "Codecs")"

Write-Output "Install libraries"

New-Item -ItemType directory -Path $installLocation -Force | Out-Null
7z e "$($archiveLocation)" -o"$($extractLocation)"
if ((Get-OSArchitectureWidth 64) -and $env:chocolateyForceX86 -ne $true) {
       $extractLocationArch = Join-Path $extractLocation '*.dll'
} else {
       $extractLocationArch = Join-Path $extractLocation '*.dll'
}

Get-ChildItem -Recurse $extractLocationArch | Select-Object Name | ConvertTo-Csv -Delimiter ';' | Out-File $path\tools\installed.csv
Copy-Item $extractLocationArch $installLocation -Recurse -Force

Write-Output "Install completed"