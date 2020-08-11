$ErrorActionPreference = 'Stop';

$meta = Get-Content -Path $env:ChocolateyPackageFolder\tools\packageArgs.json -Raw
$packageArgs = @{}
(ConvertFrom-Json $meta).psobject.properties | ForEach-Object { $packageArgs[$_.Name] = $_.Value }

$packageArgs["packageName"] = $env:ChocolateyPackageName
$packageArgs["unzipLocation"] = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
