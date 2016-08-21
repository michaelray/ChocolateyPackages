$package_name = 'purple-facebook'
$build_number = '110'
$release_string = "20160409~2a24dff~66ee77378d82~$build_number"
$libjson_url="https://github.com/dequis/purple-facebook/releases/download/downloads/libjson-glib-1.0.dll"
$libjson_checksumType="sha256"
$libjson_checksum="F6F602D99933A00BFE040330095744FEE788884318F9583149E07F85637EB699"
$libfb_url="https://cdn.rawgit.com/michaelray/purple-facebook-bin/master/libfacebook.dll/$release_string/libfacebook.dll"
$libfb_checksumType="sha256"
$libfb_checksum="ACE7DD3D16D8424B2AF0FFBEB7FFB86035578C2613E714A37FFEAB6098EDFC40"

# Find the Pidgin install directory so that the plugin DLLs can be placed into the appropriate location
$pidgin_subdir = 'Pidgin'
$pidgin_plugin_subdir = 'plugins'
$pidgin_file = 'pidgin.exe'
$pidgin_path = ''

if (Test-Path "${Env:ProgramFiles(x86)}\$pidgin_subdir\$pidgin_file")
{
  $pidgin_path = "${Env:ProgramFiles(x86)}\$pidgin_subdir\"
}
elseif (Test-Path "${Env:ProgramFiles}\$pidgin_subdir\$pidgin_file")
{
  $pidgin_path = "${Env:ProgramFiles}\$pidgin_subdir\"
}

if (!$pidgin_path)
{
  throw 'Could not find Pidgin install directory to install purple-facebook plugin'
}

# Find or create the temp directory where libjson-glib & libfacebook DLLs will be downloaded
$app_temp = Join-Path ${Env:Temp} $package_name
if (!(Test-Path $app_temp))
{
  New-Item $app_temp -Type Directory
}

# Get the DLL filename from the URL, get full temp/destination paths, then download (libjson-glib)
$libjson_filename = $libjson_url -split '/' | Select-Object -Last 1
$libjson_fulltemppath = Join-Path $app_temp $libjson_filename
$libjson_fulldestpath = Join-Path $pidgin_path $libjson_filename
Get-ChocolateyWebFile -PackageName $package_name -FileFullPath $libjson_fulltemppath -Url $libjson_url -ChecksumType $libjson_checksumType -Checksum $libjson_checksum

# Get the DLL filename from the URL, get full temp/destination paths, then download (libfacebook)
$libfb_filename = $libfb_url -split '/' | Select-Object -Last 1
$libfb_fulltemppath = Join-Path $app_temp "build$build_number-$libfb_filename"
$libfb_fulldestpath = Join-Path (Join-Path $pidgin_path $pidgin_plugin_subdir) $libfb_filename
Get-ChocolateyWebFile -PackageName $package_name -FileFullPath $libfb_fulltemppath -Url $libfb_url -ChecksumType $libfb_checksumType -Checksum $libfb_checksum

# Copy libjson-glib & libfacebook DLLs to the appropriate location
Copy-Item -Path $libjson_fulltemppath -Destination $libjson_fulldestpath -Force
Copy-Item -Path $libfb_fulltemppath -Destination $libfb_fulldestpath -Force
