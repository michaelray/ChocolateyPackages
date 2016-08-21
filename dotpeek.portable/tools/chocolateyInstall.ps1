$packageName = 'dotpeek.portable'
$version = '10.0.2'
$url = "https://download.jetbrains.com/resharper/dotPeek32_${version}.exe"
$checksumType="sha256"
$checksum="4ACC074AEDA6297A9A6F09F943DA775E991CBB33F6C23CA960AFB3C7E7A2BCCE"
$url64 = "https://download.jetbrains.com/resharper/dotPeek64_${version}.exe"
$checksum64Type="sha256"
$checksum64="0D6BC989959C4D349C223B9835B75DB2F89CB397DDB9DAEEEC3BF0EBA78A8D59"

# Create temp directory if it doesn't exist
$appTemp = [IO.Path]::Combine($ENV:Temp, $packageName)
if (!(Test-Path $appTemp))
{
  New-Item -Path $appTemp -Type Directory | Out-Null
}
$appTempFullPath = [IO.Path]::Combine($appTemp, "dotPeek_${version}.exe")

# Download package file executable to temp directory
Get-ChocolateyWebFile -PackageName $packageName -FileFullPath $appTempFullPath -Url $url -ChecksumType $checksumType -Checksum $checksum -Url64 $url64 -ChecksumType64 $checksum64Type -Checksum64 $checksum64

# Copy portable app exe to the appropriate location
$toolsDir = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$destPath = Join-Path $toolsDir 'dotPeek.exe'
Copy-Item -Path $appTempFullPath -Destination $destPath -Force

# Add start menu link
$linkPath = Join-Path ${ENV:APPDATA} "Microsoft\Windows\Start Menu\Programs\JetBrains"
$linkName = "JetBrains dotPeek ${version}.lnk"
New-Item -Path $linkPath -Type Directory -Force | Out-Null
Install-ChocolateyShortcut -ShortcutFilePath (Join-Path $linkPath $linkName) -TargetPath $destPath
