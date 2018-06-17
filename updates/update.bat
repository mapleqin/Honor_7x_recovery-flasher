@echo off 
 
timeout 5 
echo f | xcopy /Y C:\Users\Mr\Documents\GitHub\Honor_7x_recovery-flasher\RUN-ME-switcher-launcher.bat C:\Users\Mr\Documents\GitHub\Honor_7x_recovery-flasher\RUN-ME-switcher-launcher.bak 
IF EXIST C:\Users\Mr\Documents\GitHub\Honor_7x_recovery-flasher\updates\RUN-ME-switcher-launcher.bat echo f | xcopy /Y C:\Users\Mr\Documents\GitHub\Honor_7x_recovery-flasher\updates\RUN-ME-switcher-launcher.bat C:\Users\Mr\Documents\GitHub\Honor_7x_recovery-flasher\RUN-ME-switcher-launcher.bat 
timeout 5 
start C:\Users\Mr\Documents\GitHub\Honor_7x_recovery-flasher\RUN-ME-switcher-launcher.bat 
timeout 5 
exit 
