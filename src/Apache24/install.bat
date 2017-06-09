@echo off
REM Windows обнчп╖
REM set PHP_FCGI_CHILDREN=5

C:\www\tools\Apache24\bin\httpd.exe -k install
C:\www\tools\Apache24\bin\httpd.exe -k start
pause