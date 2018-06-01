<# : chooser.bat
:: launches a File... Open sort of file chooser and outputs choice(s) to the console
:: https://stackoverflow.com/a/15885133/1683264

@echo off
echo OPENING FILE CHOOSER
echo MAY TAKE JUST A MOMENT TO OPEN
setlocal

for /f "delims=" %%I in ('powershell -noprofile "iex (${%~f0} | out-string)"') do (
    set file=%%~I
)
echo THE FOLLOWING FILE HAS BEEN SELECTED
echo choosen image is %file%
echo Continue IF it is correct, Else close window to cancel
echo CAUTION THERE IS NO CHECKS AVAILABLE TO MAKE SURE YOU PICKED CORRECT IMAGE
pause
fastboot flash recovery %file%
goto :EOF

: end Batch portion / begin PowerShell hybrid chimera #>

Add-Type -AssemblyName System.Windows.Forms | Out-Null
$f = new-object Windows.Forms.OpenFileDialog
$f.InitialDirectory = pwd
$f.Filter = "Disk Image Files (*.img)|*.txt|All Files (*.*)|*.*"
$f.ShowHelp = $true
$f.Multiselect = $false
$f.ShowDialog() | Out-Null
$f.FileName
