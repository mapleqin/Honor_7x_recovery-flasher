@echo off
if not defined in_subprocess (cmd /k set in_subprocess=y ^& %0 %*) & exit )
MODE con:cols=58 lines=11
title 		Lazy Recovery Replace Nougat
color 0e
adb shell getprop ro.build.version.emui > %~dp0\version-info.txt
for /f %%i in ('FINDSTR "EmotionUI_" %~dp0\version-info.txt') do set emui=%%i
echo %emui%
if "%emui%" equ "" (echo Version check Failed to determine OS Version
echo This script will not work for you now. It will close
pause
exit)else (
echo good)
set str=%emui:~10%
echo.%str%
pause
if %str% gtr 5.2 (goto oreo
)else (
echo ok to continue)
adb reboot bootloader
echo Wait Here untill fastboot mode Loads On Phone
SET PATH=%PATH%;"%~dp0\files\nougat"
pause
fastboot oem get-build-number 2> %~dp0\build-info.txt
for /f "tokens=2" %%i in ('findstr "^(bootloader)" "%~dp0\build-info.txt"') do set Device=%%i
for /f "tokens=3" %%i in ('findstr "^(bootloader)" "%~dp0\build-info.txt"') do set Build=%%i
echo Your Current Device is = %Device% %Build%
pause
:MAIN
cls
echo 		 Choose what you need to work on.
echo(
echo                    %Device% %Build%
echo 		][************************************][
echo 		][ 1.  twrp-honor                     ][
echo 		][************************************][
echo 		][ 2.  Stock Recovery                 ][
echo 		][************************************][
echo 		][ 3.  Stock Recovery 2               ][
echo 		][************************************][
echo 		][ 4.  BND-NO-CHECK                   ][
echo 		][************************************][
echo 		][ 5.  Other file from your PC        ][
echo 		][************************************][
echo 		][ 6.  Cancel Exit and Reboot         ][
echo 		][************************************][
echo(
set /p env=Type your option [1,2,3,4,5,6] then press ENTER: || set env="0"
if /I %env%==1 set recovery=twrp-honor.img && goto flash
if /I %env%==2 set recovery=recovery.img && goto flash
if /I %env%==3 set recovery=recovery2.img && goto flash2
if /I %env%==4 set recovery=BND-RECOVERY-NoCheck.img && goto flash
if /I %env%==5 call scripts\nougat\nougat_recovery_file_flash.bat || goto end
if /I %env%==6 fastboot reboot && goto :eof 
echo(
echo %env% is not a valid option. Please try again! 
PING -n 3 127.0.0.1>nul
goto MAIN
:flash
echo THE FOLLOWING FILE HAS BEEN SELECTED
echo %recovery%
echo Continue IF it is correct, Else close window to cancel
pause
fastboot flash recovery files\nougat\%recovery%
goto end
:flash2
echo THE FOLLOWING FILE HAS BEEN SELECTED
echo %recovery%
echo Continue IF it is correct, Else close window to cancel
cd ..
cd ..
fastboot flash recovery2 files\nougat\%recovery%
:end
echo RECOVERY SHOULD NOW BE FLASHED
echo GET READY TO PULL USB PLUG OUT AND HOLD VOLUME UP
echo RIGHT AFTER YOU PRESS BUTTON TO CONTINUE
pause
fastboot reboot
goto :eof
exit
:oreo
echo You are On OREO DO NOT USE THIS
pause
exit
