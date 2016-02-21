$packageName = 'dotpeek.portable'
$version = '10.0.2'

$toolsDir = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$destPath = Join-Path $toolsDir "dotPeek.exe"
Remove-Item $destPath -Force

# Remove start menu link
$linkName = "JetBrains dotPeek ${version}.lnk"
$linkPath = Join-Path ${ENV:APPDATA} "Microsoft\Windows\Start Menu\Programs\JetBrains"
Remove-Item (Join-Path $linkPath $linkName) -Force
if ( @( Get-ChildItem $linkPath ).Count -lt 1 ) { Remove-Item $linkPath -Force }
