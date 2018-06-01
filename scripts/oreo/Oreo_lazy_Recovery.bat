@echo off
if not defined in_subprocess (cmd /k set in_subprocess=y ^& %0 %*) & exit )
title 		Lazy Recovery Replace Oreo
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
if %str% lss 5.3 (goto nougat
)else (
echo ok to continue)
adb reboot bootloader
echo Wait Here untill fastboot mode Loads On Phone
SET PATH=%PATH%;"%~dp0\files\oreo"
pause
fastboot oem get-build-number 2> %~dp0\build-info.txt
for /f "tokens=2" %%i in ('findstr "^(bootloader)" "%~dp0\build-info.txt"') do set Device=%%i
for /f "tokens=3" %%i in ('findstr "^(bootloader)" "%~dp0\build-info.txt"') do set Build=%%i
fastboot oem get-bootinfo 2> %~dp0\boot-info.txt
for /f "tokens=2" %%i in ('findstr "^(bootloader)" "%~dp0\boot-info.txt"') do set status=%%i
echo Your Current Device is = %Device% %Build% %status%
pause
if %status% equ unlocked (goto MAIN
)else (
echo bootloader is not unlocked
echo Tool will now exit
pause
exit)
pause
:MAIN
cls
echo 		 Choose what you need to work on.
echo(
echo                    %Device% %Build% %status%
echo 		][************************************][
echo 		][ 1.  complete_twrp_ramdisk          ][
echo 		][************************************][
echo 		][ 2.  Oreo Stock from beta           ][
echo 		][************************************][
echo 		][ 3.  twrp_p10_lite_0.3 Encryt works ][
echo 		][************************************][
echo 		][ 4.  Oreo No-Check                  ][
echo 		][************************************][
echo 		][ 5.  Local Image                    ][
echo 		][************************************][
echo 		][ 6.  Cancel Exit and Reboot         ][
echo 		][************************************][
echo(
echo  For performing Update simplest option is choose #1
echo(
set /p env=Type your option [1,2,3,4,5,6] then press ENTER: || set env="0"
if /I %env%==1 set recovery=complete_twrp_ramdisk.img && goto flash
if /I %env%==2 set recovery=RECOVERY_RAMDIS.img && goto flash
if /I %env%==3 set recovery=twrp_p10_lite_0.3.img && goto flash
if /I %env%==4 set recovery=RecoveryNoCheckOreoHi6250.img && goto flash
if /I %env%==5 call scripts\oreo\oreo_local_image_select.bat || goto end
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
fastboot flash recovery_ramdisk files\oreo\%recovery%
:end
echo RECOVERY SHOULD NOW BE FLASHED
echo GET READY TO PULL USB PLUG OUT AND HOLD VOLUME UP
echo RIGHT AFTER YOU PRESS BUTTON TO CONTINUE
pause
fastboot reboot
goto :eof
exit
:nougat
echo You are On NOUGAT DO NOT USE THIS
pause
exit