@echo off
REM Windows 下无效
REM set PHP_FCGI_CHILDREN=5

REM 每个进程处理的最大请求数，或设置为 Windows 环境变量
set PHP_FCGI_MAX_REQUESTS=1000
 
echo Starting PHP FastCGI...
RunHiddenConsole C:/www/tools/php-5.6.29-nts-Win32-VC11-x64/php-cgi.exe -b 127.0.0.1:9000 -c C:/www/tools/php-5.6.29-nts-Win32-VC11-x64/php.ini
REM RunHiddenConsole C:/www/tools/php-5.6.29-nts-Win32-VC11-x64/php-cgi.exe -b 127.0.0.1:9001 -c C:/www/tools/php-5.6.29-nts-Win32-VC11-x64/php.ini
REM RunHiddenConsole C:/www/tools/php-5.6.29-nts-Win32-VC11-x64/php-cgi.exe -b 127.0.0.1:9002 -c C:/www/tools/php-5.6.29-nts-Win32-VC11-x64/php.ini
REM RunHiddenConsole C:/www/tools/php-5.6.29-nts-Win32-VC11-x64/php-cgi.exe -b 127.0.0.1:9003 -c C:/www/tools/php-5.6.29-nts-Win32-VC11-x64/php.ini
REM RunHiddenConsole C:/www/tools/php-7.1.1-nts-Win32-VC14-x64/php-cgi.exe -b 127.0.0.1:9700 -c C:/www/tools/php-7.1.1-nts-Win32-VC14-x64/php.ini
REM RunHiddenConsole C:/www/tools/php-7.0.15-nts-Win32-VC14-x64/php-cgi.exe -b 127.0.0.1:9700 -c C:/www/tools/php-7.0.15-nts-Win32-VC14-x64/php.ini
 

echo Starting nginx...
RunHiddenConsole C:/www/tools/nginx/nginx.exe -p C:/www/tools/nginx