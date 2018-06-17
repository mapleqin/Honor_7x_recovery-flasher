@echo off
if not defined in_subprocess (cmd /k set in_subprocess=y ^& %0 %*) & exit )
title 		Lazy Recovery Auto Launcher
echo Waiting For device to be recognized by ADB
adb wait-for-device
adb shell getprop ro.build.version.emui > %~dp0\version-info.txt
for /f %%i in ('FINDSTR "EmotionUI_" %~dp0\version-info.txt') do set emui=%%i
echo %emui%
if "%emui%" equ "" (echo Version check Failed to determine OS Version
echo This script will not work for you now. It will close
pause
exit)else (
echo good)
set str=%emui:~10,1%
echo.%str%
pause
:menuLOOP

	call:header
	::Print our header
	::call:header
	
	::Load up our menu selections
	echo.--------------------------------------------------------------------------------
	for /f "tokens=1,2,* delims=_ " %%A in ('"C:/Windows/system32/findstr.exe /b /c:":menu_" "%~f0""') do echo.  %%B  %%C
	
	call:printstatus

	set choice=
	echo.&set /p choice= Please make a selection or hit ENTER to exit: ||GOTO:EOF
	echo.&call:menu_%choice%
	
GOTO:menuLOOP
:menu_1       Update
rd /s /q updates
IF NOT EXIST "%~dp0update" mkdir "%~dp0update"
files\wget.exe -P updates  https://raw.githubusercontent.com/mrmazakblu/Honor_7x_recovery-flasher/master/scripts/nougat/Nougat_lazy_Recovery.bat --no-check-certificate
files\wget.exe -P updates  https://raw.githubusercontent.com/mrmazakblu/Honor_7x_recovery-flasher/master/scripts/oreo/Oreo_lazy_Recovery.bat --no-check-certificate
files\wget.exe -P updates  https://raw.githubusercontent.com/mrmazakblu/Honor_7x_recovery-flasher/master/RUN-ME-switcher-launcher.bat --no-check-certificate
xcopy /y updates\Nougat_lazy_Recovery.bat scripts\nougat\Nougat_lazy_Recovery.bat
xcopy /y updates\Oreo_lazy_Recovery.bat scripts\oreo\Oreo_lazy_Recovery.bat
echo @echo off > %~dp0updates\update.bat
echo( >> %~dp0updates\update.bat
echo timeout 5 >> %~dp0updates\update.bat
echo echo f ^| xcopy /Y %~dp0RUN-ME-switcher-launcher.bat %~dp0RUN-ME-switcher-launcher.bak >> %~dp0updates\update.bat
echo IF EXIST %~dp0updates\RUN-ME-switcher-launcher.bat echo f ^| xcopy /Y %~dp0updates\RUN-ME-switcher-launcher.bat %~dp0RUN-ME-switcher-launcher.bat >> %~dp0updates\update.bat
echo timeout 5 >> %~dp0updates\update.bat
echo start %~dp0RUN-ME-switcher-launcher.bat >> %~dp0updates\update.bat
echo timeout 5 >> %~dp0updates\update.bat
echo exit >> %~dp0updates\update.bat
start %~dp0updates\update.bat
exit
:menu_2       Run
if %str% equ 8 call scripts\oreo\Oreo_lazy_Recovery.bat
if %str% equ 5 call scripts\nougat\Nougat_lazy_Recovery.bat
GOTO:EOF

:header  
cls        
color 0e
echo.--------------------------------------------------------------------------------
echo.
::adb kill-server
::adb start-server
echo.--------------------------------------------------------------------------------
adb devices
timeout 5 > nul
fastboot devices
timeout 3 > nul
::adb kill-server
cls	
color 0b
GOTO:EOF

:printstatus
echo.
echo. 
echo. 
echo. 
echo.--------------------------------------------------------------------------------
GOTO:EOF
