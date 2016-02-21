$packageName = 'dotpeek.portable'
$version = '10.0.2'
$url = "https://download.jetbrains.com/resharper/dotPeek32_${version}.exe"
$url64 = "https://download.jetbrains.com/resharper/dotPeek64_${version}.exe"

# Create temp directory if it doesn't exist
$appTemp = [IO.Path]::Combine($ENV:Temp, $packageName)
if (!(Test-Path $appTemp))
{
  New-Item -Path $appTemp -Type Directory | Out-Null
}
$appTempFullPath = [IO.Path]::Combine($appTemp, "dotPeek_${version}.exe")

# Download package file executable to temp directory
Get-ChocolateyWebFile $packageName $appTempFullPath $url $url64

# Copy portable app exe to the appropriate location
$toolsDir = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$destPath = Join-Path $toolsDir 'dotPeek.exe'
Copy-Item -Path $appTempFullPath -Destination $destPath -Force

# Add start menu link
$linkPath = Join-Path ${ENV:APPDATA} "Microsoft\Windows\Start Menu\Programs\JetBrains"
$linkName = "JetBrains dotPeek ${version}.lnk"
New-Item -Path $linkPath -Type Directory -Force | Out-Null
Install-ChocolateyShortcut -ShortcutFilePath (Join-Path $linkPath $linkName) -TargetPath $destPath
