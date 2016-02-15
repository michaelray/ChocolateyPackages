$packageName = 'dotpeek.portable'
$version = '10.0.2'
$toolsDir = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$fileName = "dotPeek_${version}.exe"
$destPath = Join-Path $toolsDir $fileName
$url = "https://download.jetbrains.com/resharper/dotPeek32_${version}.exe"
$url64 = "https://download.jetbrains.com/resharper/dotPeek64_${version}.exe"

Get-ChocolateyWebFile $packageName $destPath $url $url64

# Add start menu link
$linkPath = Join-Path ${ENV:APPDATA} "Microsoft\Windows\Start Menu\Programs\JetBrains"
$linkName = "JetBrains dotPeek ${version}.lnk"
New-Item -Path $linkPath -ItemType directory -Force | Out-Null
Install-ChocolateyShortcut -ShortcutFilePath (Join-Path $linkPath $linkName) -TargetPath $destPath
