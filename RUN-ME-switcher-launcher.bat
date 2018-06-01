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
:update
files\wget.exe -P updates\first  https://raw.githubusercontent.com/mrmazakblu/*** --no-check-certificate
files\wget.exe -P updates\second  https://raw.githubusercontent.com/mrmazakblu/*** --no-check-certificate
::rd /s /q updates
:run
if %str% equ 8 call scripts\oreo\Oreo_lazy_Recovery.bat
if %str% equ 5 call scripts\nougat\Nougat_lazy_Recovery.bat
pause
exit
