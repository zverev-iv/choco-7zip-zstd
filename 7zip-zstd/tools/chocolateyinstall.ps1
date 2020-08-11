$ErrorActionPreference = 'Stop';

$meta = Get-Content -Path $env:ChocolateyPackageFolder\tools\packageArgs.json -Raw
$packageArgs = @{}
(ConvertFrom-Json $meta).psobject.properties | ForEach-Object { $packageArgs[$_.Name] = $_.Value }

$filename = ""
$filePath = if ((Get-OSArchitectureWidth 64) -and $env:chocolateyForceX86 -ne $true) {
       $filename = Split-Path $packageArgs["url64bit"] -Leaf}
else { $filename = Split-Path $packageArgs["url"] -Leaf }

if(!$filename)
{
  Write-ChocolateyFailure $packageArgs["packageName"] "filename not found in package url"
}

$packageArgs["packageName"] = "$($env:ChocolateyPackageName)"
$packageArgs["fileFullPath"] = "$(Join-Path (Split-Path -parent $MyInvocation.MyCommand.Definition) $filename)"

Get-ChocolateyWebFile @packageArgs 
#TODO: unpack to working directory


