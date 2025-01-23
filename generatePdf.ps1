$ScriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Definition
$BashScriptPath = Join-Path $ScriptDirectory "generatePdf.sh"
$WSLPath = wsl -- bash -c "wslpath '$BashScriptPath'"
wsl -- bash -c "'$WSLPath'"
