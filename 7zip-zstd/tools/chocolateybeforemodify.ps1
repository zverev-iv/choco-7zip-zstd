﻿$ErrorActionPreference = 'Stop';

$path = Get-ChocolateyPath -PathType 'PackagePath'
$installed = Get-Content -Path $path\tools\installed.csv -Raw | ConvertFrom-Csv -Delimiter ';'

$spliter = "path to executable:"
$7zLocation = "$(Split-Path -parent ((7z --shimgen-noop | Select-String $spliter) -split $spliter | ForEach-Object Trim)[1])"
$installLocation = "$(Join-Path $7zLocation "Codecs")"

Write-Output "Remove libraries"

ForEach($file in $installed) {
  Remove-Item "$(Join-Path $installLocation $file.Name)" -Force
}

Write-Output "Remove completed"