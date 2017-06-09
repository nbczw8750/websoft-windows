@echo off
REM Windows обнчп╖
REM set PHP_FCGI_CHILDREN=5

C:\www\tools\Apache24\bin\httpd.exe -k stop
C:\www\tools\Apache24\bin\httpd.exe -k uninstall
pause