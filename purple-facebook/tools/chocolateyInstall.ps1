$package_name = 'purple-facebook'
$build_number = '99'
$release_string = "20160115~820cbb4~ad2ee74b913a~$build_number"
$libjson_url="https://github.com/jgeboski/purple-facebook/releases/download/downloads/libjson-glib-1.0.dll"
$libfb_url="https://github.com/michaelray/purple-facebook-bin/raw/master/libfacebook.dll/$release_string/libfacebook.dll"

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
Get-ChocolateyWebFile -packageName $package_name -fileFullPath $libjson_fulltemppath -url $libjson_url

# Get the DLL filename from the URL, get full temp/destination paths, then download (libfacebook)
$libfb_filename = $libfb_url -split '/' | Select-Object -Last 1
$libfb_fulltemppath = Join-Path $app_temp "build$build_number-$libfb_filename"
$libfb_fulldestpath = Join-Path (Join-Path $pidgin_path $pidgin_plugin_subdir) $libfb_filename
Get-ChocolateyWebFile -packageName $package_name -fileFullPath $libfb_fulltemppath -url $libfb_url

# Copy libjson-glib & libfacebook DLLs to the appropriate location
Copy-Item -Path $libjson_fulltemppath -Destination $libjson_fulldestpath
Copy-Item -Path $libfb_fulltemppath -Destination $libfb_fulldestpath
