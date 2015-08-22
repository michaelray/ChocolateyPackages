$package_name = 'purple-facebook'

$libjson_filename = 'libjson-glib-1.0.dll'
$libfb_filename = 'libfacebook.dll'

# Find the Pidgin install directory so that the plugin DLLs can be removed the appropriate location
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

# Remove libjson-glib & libfacebook DLLs from the appropriate locations
$libjson_fullpath = Join-Path $pidgin_path $libjson_filename
Remove-Item $libjson_fullpath

$libfb_fullpath = Join-Path (Join-Path $pidgin_path $pidgin_plugin_subdir) $libfb_filename
Remove-Item $libfb_fullpath
