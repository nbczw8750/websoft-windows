; 该脚本使用 HM VNISEdit 脚本编辑器向导产生

; 安装程序初始定义常量
!define PRODUCT_NAME "web环境一键搭建"
!define PRODUCT_VERSION "1.4.1"
!define PRODUCT_PUBLISHER "宁波昱晟信息科技有限公司"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

#注意安：装程序不能与卸载程序相同！#
!define MyMutex_Install     "web环境一键搭建_Install"
!define MyMutex_UnInstall   "web环境一键搭建_UnInstall"

SetCompressor lzma

; ------ MUI 现代界面定义 (1.67 版本以上兼容) ------
!include "MUI.nsh"
!include "WordFunc.nsh"

; MUI 预定义常量
!define MUI_ABORTWARNING
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\modern-install.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"

; 欢迎页面
!insertmacro MUI_PAGE_WELCOME
; 许可协议页面
!insertmacro MUI_PAGE_LICENSE "授权.txt"
; 组件选择页面
!insertmacro MUI_PAGE_COMPONENTS
; 安装目录选择页面
!insertmacro MUI_PAGE_DIRECTORY
; 安装过程页面
!insertmacro MUI_PAGE_INSTFILES
; 安装完成页面
!insertmacro MUI_PAGE_FINISH

; 安装卸载过程页面
!insertmacro MUI_UNPAGE_INSTFILES

; 安装界面包含的语言设置
!insertmacro MUI_LANGUAGE "SimpChinese"

; 安装预释放文件
!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS
; ------ MUI 现代界面定义结束 ------

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "Setup.exe"
InstallDir "C:\www\websoft"
ShowInstDetails show
ShowUnInstDetails show

Function .onInit
	InitPluginsDir
	Call CreateMutex
	;禁止重复安装程序
	ReadRegStr $0 HKLM '${PRODUCT_UNINST_KEY}' "Installed"
	StrLen $1 $0
	IntCmp $1 0 +3 +1 +1
	MessageBox MB_OK|MB_USERICON '$(^Name) 已安装在计算机中。如需重新安装，请卸载已有的安装'
	Quit
FunctionEnd

Section "主程序（必须）" main
	SectionIn RO

	SetOutPath "$INSTDIR\wwwroot"
  SetOverwrite ifnewer
  File "src\wwwroot\50x.html"
  File "src\wwwroot\apache.html"
  File "src\wwwroot\l.php"
  File "src\wwwroot\nginx.html"
  File "src\wwwroot\phpinfo.php"
  File "src\wwwroot\yhtz.php"
  
  
  SetOutPath "$INSTDIR\tmp"
  SetOverwrite ifnewer
  File /r "src\tmp\*.*"
  SetOutPath "$INSTDIR"
  File "src\使用说明.txt"
SectionEnd

Section "phpmyadmin" phpmyadmin
  SetOutPath "$INSTDIR\wwwroot\phpmyadmin"
  SetOverwrite ifnewer
  File /r "src\wwwroot\phpmyadmin\*.*"
SectionEnd

Section "kodexplorer" kodexplorer
  SetOutPath "$INSTDIR\wwwroot\kodexplorer"
  SetOverwrite ifnewer
  File /r "src\wwwroot\kodexplorer\*.*"
SectionEnd

Section "nginx" nginx
  SetOutPath "$INSTDIR\nginx"
  File /r "src\nginx\*.*"
  
  #-- 替换网站根目录 --#
  Push C:/www/tools #text to be replaced
	Push $INSTDIR #replace with
	Push all #replace all occurrences
	Push all #replace all occurrences
	Push $INSTDIR\nginx\conf\nginx.conf #file to replace in
 	Call AdvReplaceInFile
  
	#-- 替换启动路径 --#
  Push C:/www/tools #text to be replaced
	Push $INSTDIR #replace with
	Push all #replace all occurrences
	Push all #replace all occurrences
	Push $INSTDIR\nginx\start_nginx.bat #file to replace in
 	Call AdvReplaceInFile
 	
 	#-- 替换服务脚本路径 --#
  Push C:\www\tools #text to be replaced
	Push $INSTDIR #replace with
	Push all #replace all occurrences
	Push all #replace all occurrences
	Push $INSTDIR\nginx\nginx-service.xml #file to replace in
 	Call AdvReplaceInFile
 	
 	#-- 替换服务安装脚本路径 --#
  Push C:\www\tools #text to be replaced
	Push $INSTDIR #replace with
	Push all #replace all occurrences
	Push all #replace all occurrences
	Push $INSTDIR\nginx\nginx-service-install.bat #file to replace in
 	Call AdvReplaceInFile

 	#-- 替换服务卸载脚本路径 --#
  Push C:\www\tools #text to be replaced
	Push $INSTDIR #replace with
	Push all #replace all occurrences
	Push all #replace all occurrences
	Push $INSTDIR\nginx\nginx-service-uninstall.bat #file to replace in
 	Call AdvReplaceInFile
 	
SectionEnd

Section "Apache" Apache
  SetOutPath "$INSTDIR\Apache24"
  File /r "src\Apache24\*.*"
  
  #-- 替换启动路径 --#
  ${WordReplace} $INSTDIR "\" "/" "+" $R0
  Push C:/www/tools #text to be replaced
	Push $R0 #replace with
	Push all #replace all occurrences
	Push all #replace all occurrences
	Push $INSTDIR\Apache24\conf\httpd.conf #file to replace in
 	Call AdvReplaceInFile
 	
 	#-- 替换启动路径 --#
  Push C:\www\tools #text to be replaced
	Push $INSTDIR #replace with
	Push all #replace all occurrences
	Push all #replace all occurrences
	Push $INSTDIR\Apache24\conf\httpd.conf #file to replace in
 	Call AdvReplaceInFile
 	
 	#-- 替换启动路径 --#
  Push C:\www\tools #text to be replaced
	Push $INSTDIR #replace with
	Push all #replace all occurrences
	Push all #replace all occurrences
	Push $INSTDIR\Apache24\install.bat #file to replace in
 	Call AdvReplaceInFile
 	
 	#-- 替换启动路径 --#
  Push C:\www\tools #text to be replaced
	Push $INSTDIR #replace with
	Push all #replace all occurrences
	Push all #replace all occurrences
	Push $INSTDIR\Apache24\uninstall.bat #file to replace in
 	Call AdvReplaceInFile
 	
SectionEnd

Section "php5.6.29" php5.6.29
  SetOutPath "$INSTDIR\php-5.6.29-nts-Win32-VC11-x64"
  File /r "src\php-5.6.29-nts-Win32-VC11-x64\*.*"
  
  #-- 修改php.ini文件 --#
  WriteINIStr $INSTDIR\php-5.6.29-nts-Win32-VC11-x64\php.ini PHP upload_tmp_dir "$INSTDIR\tmp\php-5.6.29-nts-Win32-VC11-x64"
  WriteINIStr $INSTDIR\php-5.6.29-nts-Win32-VC11-x64\php.ini PHP sys_temp_dir "$INSTDIR\tmp\php-5.6.29-nts-Win32-VC11-x64"
  WriteINIStr $INSTDIR\php-5.6.29-nts-Win32-VC11-x64\php.ini Session session.save_path "$INSTDIR\tmp\php-5.6.29-nts-Win32-VC11-x64"
  WriteINIStr $INSTDIR\php-5.6.29-nts-Win32-VC11-x64\php.ini soap soap.wsdl_cache_dir "$INSTDIR\tmp\php-5.6.29-nts-Win32-VC11-x64"

SectionEnd

Section "php7.0.15" php7.0.15
  SetOutPath "$INSTDIR\php-7.0.15-nts-Win32-VC14-x64"
  File /r "src\php-7.0.15-nts-Win32-VC14-x64\*.*"
  
  WriteINIStr $INSTDIR\php-7.0.15-nts-Win32-VC14-x64\php.ini PHP upload_tmp_dir "$INSTDIR\tmp\php-7.0.15-nts-Win32-VC14-x64"
  WriteINIStr $INSTDIR\php-7.0.15-nts-Win32-VC14-x64\php.ini PHP sys_temp_dir "$INSTDIR\tmp\php-7.0.15-nts-Win32-VC14-x64"
  WriteINIStr $INSTDIR\php-7.0.15-nts-Win32-VC14-x64\php.ini Session session.save_path "$INSTDIR\tmp\php-7.0.15-nts-Win32-VC14-x64"
  WriteINIStr $INSTDIR\php-7.0.15-nts-Win32-VC14-x64\php.ini soap soap.wsdl_cache_dir "$INSTDIR\tmp\php-7.0.15-nts-Win32-VC14-x64"
  
SectionEnd

Section "php7.1.1" php7.1.1
  SetOutPath "$INSTDIR\php-7.1.1-nts-Win32-VC14-x64"
  File /r "src\php-7.1.1-nts-Win32-VC14-x64\*.*"
  
  WriteINIStr $INSTDIR\php-7.1.1-nts-Win32-VC14-x64\php.ini PHP upload_tmp_dir "$INSTDIR\tmp\php-7.1.1-nts-Win32-VC14-x64"
  WriteINIStr $INSTDIR\php-7.1.1-nts-Win32-VC14-x64\php.ini PHP sys_temp_dir "$INSTDIR\tmp\php-7.1.1-nts-Win32-VC14-x64"
  WriteINIStr $INSTDIR\php-7.1.1-nts-Win32-VC14-x64\php.ini Session session.save_path "$INSTDIR\tmp\php-7.1.1-nts-Win32-VC14-x64"
  WriteINIStr $INSTDIR\php-7.1.1-nts-Win32-VC14-x64\php.ini soap soap.wsdl_cache_dir "$INSTDIR\tmp\php-7.1.1-nts-Win32-VC14-x64"
  
SectionEnd

Section "memcached" memcached

  SetOutPath "$INSTDIR\memcached"
  File /r "src\memcached\*.*"
  
  #-- 替换启动路径 --#
  Push C:\www\tools #text to be replaced
	Push $INSTDIR #replace with
	Push all #replace all occurrences
	Push all #replace all occurrences
	Push $INSTDIR\memcached\install.bat #file to replace in
 	Call AdvReplaceInFile
 	
  #-- 替换启动路径 --#
  Push C:\www\tools #text to be replaced
	Push $INSTDIR #replace with
	Push all #replace all occurrences
	Push all #replace all occurrences
	Push $INSTDIR\memcached\uninstall.bat #file to replace in
 	Call AdvReplaceInFile
 	

  SetOutPath "$INSTDIR\wwwroot\memadmin"
  SetOverwrite ifnewer
  File /r "src\wwwroot\memadmin\*.*"
 	
SectionEnd
Section "memadmin" memadmin
  SetOutPath "$INSTDIR\wwwroot\memadmin"
  SetOverwrite ifnewer
  File /r "src\wwwroot\memadmin\*.*"

SectionEnd

Section "orcle客户端" oracle_client
  SetOutPath "$INSTDIR\oracle_client_10_2"
  File /r "src\oracle_client_10_2\*.*"
  
  #-- path --#
	ReadRegStr $0 HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "Path"
	WriteRegExpandStr HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "Path" "$0;$INSTDIR\oracle_client_10_2"
	
SectionEnd

Section "tools" tools
  SetOutPath "$INSTDIR\tools"
  File /r "src\tools\*.*"
SectionEnd

Section "sqlsrv客户端驱动安装包" sqlsrv
  SetOutPath "$INSTDIR\setup\sqlsrv_client_setup"
  File /r "src\setup\sqlsrv_client_setup\*.*"
SectionEnd

Section "visual c++安装包" vs
  SetOutPath "$INSTDIR\setup\vs_setup"
  File /r "src\setup\vs_setup\*.*"
SectionEnd

Section "redis安装包" redis
  
  SetOutPath "$INSTDIR\setup\redis"
  File /r "src\setup\redis\*.*"
  
  SetOutPath "$INSTDIR\wwwroot\redisadmin"
  SetOverwrite ifnewer
  File /r "src\wwwroot\redisadmin\*.*"
SectionEnd
Section "redisadmin" redisadmin
  SetOutPath "$INSTDIR\wwwroot\redisadmin"
  SetOverwrite ifnewer
  File /r "src\wwwroot\redisadmin\*.*"
SectionEnd
Section "mysql5.7.18" mysql5.7.18
  SetOutPath "$INSTDIR\database\mysql-5.7.18\mysql"
  SetOverwrite ifnewer
  File /r "src\database\mysql-5.7.18\mysql\*.*"
  
  #-- 替换路径 --#
  Push C:\www\websoft #text to be replaced
	Push $INSTDIR #replace with
	Push all #replace all occurrences
	Push all #replace all occurrences
	Push $INSTDIR\database\mysql-5.7.18\mysql\install.bat #file to replace in
 	Call AdvReplaceInFile
 	
 	#-- 替换路径 --#
  Push C:\www\websoft #text to be replaced
	Push $INSTDIR #replace with
	Push all #replace all occurrences
	Push all #replace all occurrences
	Push $INSTDIR\database\mysql-5.7.18\mysql\uninstall.bat #file to replace in
 	Call AdvReplaceInFile
 	
	#-- 创建数据目录 --#
 	CreateDirectory "$INSTDIR\database\mysql-5.7.18"
 	CreateDirectory "$INSTDIR\database\mysql-5.7.18\ProgramData"
 	CreateDirectory "$INSTDIR\database\mysql-5.7.18\ProgramData\data"
 	CreateDirectory "$INSTDIR\database\mysql-5.7.18\ProgramData\upload"
 	
 	WriteINIStr $INSTDIR\database\mysql-5.7.18\mysql\my.ini mysqld basedir "$INSTDIR/database/mysql-5.7.18/mysql"
 	WriteINIStr $INSTDIR\database\mysql-5.7.18\mysql\my.ini mysqld datadir "$INSTDIR/database/mysql-5.7.18/ProgramData/data"
 	WriteINIStr $INSTDIR\database\mysql-5.7.18\mysql\my.ini mysqld secure-file-priv "$INSTDIR/database/mysql-5.7.18/ProgramData/upload"

	#-- path --#
	ReadRegStr $0 HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "Path"
	WriteRegExpandStr HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "Path" "$0;$INSTDIR\database\mysql-5.7.18\mysql\bin"

SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Installed" "1"
SectionEnd

#-- 根据 NSIS 脚本编辑规则，所有 Function 区段必须放置在 Section 区段之后编写，以避免安装程序出现未可预知的问题。--#

; 区段组件描述
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${main} "主程序必选"
  !insertmacro MUI_DESCRIPTION_TEXT ${phpmyadmin} "mysqlweb管理系统"
  !insertmacro MUI_DESCRIPTION_TEXT ${kodexplorer} "芒果云-资源管理器"
  !insertmacro MUI_DESCRIPTION_TEXT ${nginx} "nginx-1.10.3 带服务安装脚本和启动关闭脚本"
  !insertmacro MUI_DESCRIPTION_TEXT ${Apache} "Apache2.4.25 vc11编译"
  !insertmacro MUI_DESCRIPTION_TEXT ${php5.6.29} "php5.6.29 vc11 64位编译"
  !insertmacro MUI_DESCRIPTION_TEXT ${php7.0.15} "php7.0.15 vc14 64位编译"
  !insertmacro MUI_DESCRIPTION_TEXT ${php7.1.1} "php7.1.1 vc14 64位编译 不支持memcached"
  !insertmacro MUI_DESCRIPTION_TEXT ${memcached} "memcached缓存服务和memcached管理系统"
  !insertmacro MUI_DESCRIPTION_TEXT ${memadmin} "memcached管理系统"
  !insertmacro MUI_DESCRIPTION_TEXT ${oracle_client} "php连接oracle需要的驱动"
  !insertmacro MUI_DESCRIPTION_TEXT ${tools} "包含端口测试脚本和文本编辑器绿色版"
  !insertmacro MUI_DESCRIPTION_TEXT ${sqlsrv} "里面包含microsoft sql server 2008 native client和Microsoft? ODBC Driver 13 for SQL Serve"
  !insertmacro MUI_DESCRIPTION_TEXT ${vs} "Apache和php5.6需要vc11的支持，php7需要vc14的支持"
  !insertmacro MUI_DESCRIPTION_TEXT ${redis} "redis3.2 no sql 和 redis管理系统"
  !insertmacro MUI_DESCRIPTION_TEXT ${redisadmin} "redis管理系统"
  !insertmacro MUI_DESCRIPTION_TEXT ${mysql5.7.18} "mysql5.7.18"
!insertmacro MUI_FUNCTION_DESCRIPTION_END

/******************************
 *  以下是安装程序的卸载部分  *
 ******************************/

Section Uninstall
	SetOutPath '$INSTDIR'

	IfFileExists $INSTDIR\nginx-service-uninstall.bat 0 +2
		ExecWait '$INSTDIR\nginx-service-uninstall.bat'
		
	IfFileExists $INSTDIR\nginx\stop_nginx.bat 0 +2
		ExecWait '$INSTDIR\nginx\stop_nginx.bat'

	IfFileExists $INSTDIR\Apache24\uninstall.bat 0 +2
		ExecWait '$INSTDIR\Apache24\uninstall.bat'
		
	IfFileExists $INSTDIR\memcached\uninstall.bat 0 +2
		ExecWait '$INSTDIR\memcached\uninstall.bat'

	IfFileExists $INSTDIR\database\mysql-5.7.18\mysql\uninstall.bat 0 +2
		ExecWait '$INSTDIR\database\mysql-5.7.18\mysql\uninstall.bat'

  Delete "$INSTDIR\uninst.exe"
  Delete "$INSTDIR\使用说明.txt"

	RMDir /r "$INSTDIR\tmp"
  RMDir /r "$INSTDIR\php-7.1.1-nts-Win32-VC14-x64"
  RMDir /r "$INSTDIR\php-7.0.15-nts-Win32-VC14-x64"
  RMDir /r "$INSTDIR\php-5.6.29-nts-Win32-VC11-x64"
  RMDir /r "$INSTDIR\oracle_client_10_2"
  RMDir /r "$INSTDIR\nginx"
  RMDir /r "$INSTDIR\memcached"
  RMDir /r "$INSTDIR\Apache24"
  RMDir /r "$INSTDIR\tools"
  RMDir /r "$INSTDIR\setup"
  RMDir /r "$INSTDIR\database\mysql-5.7.18\mysql"
  ;RMDir /r "$INSTDIR\vs_setup"

  ;RMDir /r "$INSTDIR"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  
  ReadRegStr $R0 HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "Path"
	${WordReplace} $R0 ";$INSTDIR\oracle_client_10_2" "" "+" $R1
	;MessageBox MB_OK|MB_USERICON '$R0 - $INSTDIR - $R1 '
	WriteRegExpandStr HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "Path" "$R1"

	ReadRegStr $R0 HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "Path"
	${WordReplace} $R0 ";$INSTDIR\database\mysql-5.7.18\mysql\bin" "" "+" $R1
	;MessageBox MB_OK|MB_USERICON '$R0 - $INSTDIR - $R1 '
	WriteRegExpandStr HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "Path" "$R1"
	
  SetAutoClose true
SectionEnd


#-- 根据 NSIS 脚本编辑规则，所有 Function 区段必须放置在 Section 区段之后编写，以避免安装程序出现未可预知的问题。--#

Function un.onInit
	Call un.CreateMutex
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "您确实要完全移除 $(^Name) ，及其所有的组件？" IDYES +2
  Abort
FunctionEnd

Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) 已成功地从您的计算机移除。"
FunctionEnd

#-- 替换文件内容函数 --#

Function AdvReplaceInFile
	Exch $0 ;file to replace in
	Exch
	Exch $1 ;number to replace after
	Exch
	Exch 2
	Exch $2 ;replace and onwards
	Exch 2
	Exch 3
	Exch $3 ;replace with
	Exch 3
	Exch 4
	Exch $4 ;to replace
	Exch 4
	Push $5 ;minus count
	Push $6 ;universal
	Push $7 ;end string
	Push $8 ;left string
	Push $9 ;right string
	Push $R0 ;file1
	Push $R1 ;file2
	Push $R2 ;read
	Push $R3 ;universal
	Push $R4 ;count (onwards)
	Push $R5 ;count (after)
	Push $R6 ;temp file name

	  GetTempFileName $R6
	  FileOpen $R1 $0 r ;file to search in
	  FileOpen $R0 $R6 w ;temp file
	   StrLen $R3 $4
	   StrCpy $R4 -1
	   StrCpy $R5 -1

	loop_read:
	 ClearErrors
	 FileRead $R1 $R2 ;read line
	 IfErrors exit

	   StrCpy $5 0
	   StrCpy $7 $R2

	loop_filter:
	   IntOp $5 $5 - 1
	   StrCpy $6 $7 $R3 $5 ;search
	   StrCmp $6 "" file_write1
	   StrCmp $6 $4 0 loop_filter

	StrCpy $8 $7 $5 ;left part
	IntOp $6 $5 + $R3
	IntCmp $6 0 is0 not0
	is0:
	StrCpy $9 ""
	Goto done
	not0:
	StrCpy $9 $7 "" $6 ;right part
	done:
	StrCpy $7 $8$3$9 ;re-join

	IntOp $R4 $R4 + 1
	StrCmp $2 all loop_filter
	StrCmp $R4 $2 0 file_write2
	IntOp $R4 $R4 - 1

	IntOp $R5 $R5 + 1
	StrCmp $1 all loop_filter
	StrCmp $R5 $1 0 file_write1
	IntOp $R5 $R5 - 1
	Goto file_write2

	file_write1:
	 FileWrite $R0 $7 ;write modified line
	Goto loop_read

	file_write2:
	 FileWrite $R0 $R2 ;write unmodified line
	Goto loop_read

	exit:
	  FileClose $R0
	  FileClose $R1

	   SetDetailsPrint none
	  Delete $0
	  Rename $R6 $0
	  Delete $R6
	   SetDetailsPrint both

	Pop $R6
	Pop $R5
	Pop $R4
	Pop $R3
	Pop $R2
	Pop $R1
	Pop $R0
	Pop $9
	Pop $8
	Pop $7
	Pop $6
	Pop $5
	Pop $0
	Pop $1
	Pop $2
	Pop $3
	Pop $4
FunctionEnd

Function CreateMutex
#检查安装互斥：#
ReCheck:
  System::Call 'kernel32::CreateMutexA(i 0, i 0, t "${MyMutex_Install}") i .R1 ?e'
Pop $R0
  System::Call 'kernel32::CloseHandle(i R1) i.s'
#检查卸载互斥：#
  System::Call 'kernel32::CreateMutexA(i 0, i 0, t "${MyMutex_UnInstall}") i .R3 ?e'
Pop $R2
  System::Call 'kernel32::CloseHandle(i R3) i.s'
#判断安装/卸载互斥的存在#
${If} $R0 != 0
  MessageBox MB_RetryCancel|MB_ICONEXCLAMATION "安装程序已经运行！" IdRetry ReCheck
Quit
${ElseIf} $R2 != 0
  MessageBox MB_RetryCancel|MB_ICONEXCLAMATION "卸载程序已经运行！" IdRetry ReCheck
Quit
${Else}
#创建安装互斥：#
  System::Call 'kernel32::CreateMutexA(i 0, i 0, t "${MyMutex_Install}") i .R1 ?e'
Pop $R0
  StrCmp $R0 0 +2
Quit
${EndIf}
FunctionEnd

Function Un.CreateMutex
#检查安装互斥：#
ReCheck:
  System::Call 'kernel32::CreateMutexA(i 0, i 0, t "${MyMutex_Install}") i .R1 ?e'
Pop $R0
  System::Call 'kernel32::CloseHandle(i R1) i.s'
#检查卸载互斥：#
CheckUnInstall:
  System::Call 'kernel32::CreateMutexA(i 0, i 0, t "${MyMutex_UnInstall}") i .R3 ?e'
Pop $R2
  System::Call 'kernel32::CloseHandle(i R3) i.s'
#判断安装/卸载互斥的存在#
${If} $R0 != 0
  MessageBox MB_RetryCancel|MB_ICONEXCLAMATION "安装程序已经运行！" IdRetry ReCheck
Quit
${ElseIf} $R2 != 0
  MessageBox MB_RetryCancel|MB_ICONEXCLAMATION "卸载程序已经运行！" IdRetry ReCheck
Quit
${Else}
#创建卸载互斥：#
  System::Call 'kernel32::CreateMutexA(i 0, i 0, t "${MyMutex_UnInstall}") i .R1 ?e'
Pop $R0
  StrCmp $R0 0 +2
Quit
${EndIf}
FunctionEnd

