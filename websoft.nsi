; �ýű�ʹ�� HM VNISEdit �ű��༭���򵼲���

; ��װ�����ʼ���峣��
!define PRODUCT_NAME "web����һ���"
!define PRODUCT_VERSION "1.4.1"
!define PRODUCT_PUBLISHER "����������Ϣ�Ƽ����޹�˾"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

#ע�ⰲ��װ��������ж�س�����ͬ��#
!define MyMutex_Install     "web����һ���_Install"
!define MyMutex_UnInstall   "web����һ���_UnInstall"

SetCompressor lzma

; ------ MUI �ִ����涨�� (1.67 �汾���ϼ���) ------
!include "MUI.nsh"
!include "WordFunc.nsh"

; MUI Ԥ���峣��
!define MUI_ABORTWARNING
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\modern-install.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"

; ��ӭҳ��
!insertmacro MUI_PAGE_WELCOME
; ���Э��ҳ��
!insertmacro MUI_PAGE_LICENSE "��Ȩ.txt"
; ���ѡ��ҳ��
!insertmacro MUI_PAGE_COMPONENTS
; ��װĿ¼ѡ��ҳ��
!insertmacro MUI_PAGE_DIRECTORY
; ��װ����ҳ��
!insertmacro MUI_PAGE_INSTFILES
; ��װ���ҳ��
!insertmacro MUI_PAGE_FINISH

; ��װж�ع���ҳ��
!insertmacro MUI_UNPAGE_INSTFILES

; ��װ�����������������
!insertmacro MUI_LANGUAGE "SimpChinese"

; ��װԤ�ͷ��ļ�
!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS
; ------ MUI �ִ����涨����� ------

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "Setup.exe"
InstallDir "C:\www\websoft"
ShowInstDetails show
ShowUnInstDetails show

Function .onInit
	InitPluginsDir
	Call CreateMutex
	;��ֹ�ظ���װ����
	ReadRegStr $0 HKLM '${PRODUCT_UNINST_KEY}' "Installed"
	StrLen $1 $0
	IntCmp $1 0 +3 +1 +1
	MessageBox MB_OK|MB_USERICON '$(^Name) �Ѱ�װ�ڼ�����С��������°�װ����ж�����еİ�װ'
	Quit
FunctionEnd

Section "�����򣨱��룩" main
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
  File "src\ʹ��˵��.txt"
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
  
  #-- �滻��վ��Ŀ¼ --#
  Push C:/www/tools #text to be replaced
	Push $INSTDIR #replace with
	Push all #replace all occurrences
	Push all #replace all occurrences
	Push $INSTDIR\nginx\conf\nginx.conf #file to replace in
 	Call AdvReplaceInFile
  
	#-- �滻����·�� --#
  Push C:/www/tools #text to be replaced
	Push $INSTDIR #replace with
	Push all #replace all occurrences
	Push all #replace all occurrences
	Push $INSTDIR\nginx\start_nginx.bat #file to replace in
 	Call AdvReplaceInFile
 	
 	#-- �滻����ű�·�� --#
  Push C:\www\tools #text to be replaced
	Push $INSTDIR #replace with
	Push all #replace all occurrences
	Push all #replace all occurrences
	Push $INSTDIR\nginx\nginx-service.xml #file to replace in
 	Call AdvReplaceInFile
 	
 	#-- �滻����װ�ű�·�� --#
  Push C:\www\tools #text to be replaced
	Push $INSTDIR #replace with
	Push all #replace all occurrences
	Push all #replace all occurrences
	Push $INSTDIR\nginx\nginx-service-install.bat #file to replace in
 	Call AdvReplaceInFile

 	#-- �滻����ж�ؽű�·�� --#
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
  
  #-- �滻����·�� --#
  ${WordReplace} $INSTDIR "\" "/" "+" $R0
  Push C:/www/tools #text to be replaced
	Push $R0 #replace with
	Push all #replace all occurrences
	Push all #replace all occurrences
	Push $INSTDIR\Apache24\conf\httpd.conf #file to replace in
 	Call AdvReplaceInFile
 	
 	#-- �滻����·�� --#
  Push C:\www\tools #text to be replaced
	Push $INSTDIR #replace with
	Push all #replace all occurrences
	Push all #replace all occurrences
	Push $INSTDIR\Apache24\conf\httpd.conf #file to replace in
 	Call AdvReplaceInFile
 	
 	#-- �滻����·�� --#
  Push C:\www\tools #text to be replaced
	Push $INSTDIR #replace with
	Push all #replace all occurrences
	Push all #replace all occurrences
	Push $INSTDIR\Apache24\install.bat #file to replace in
 	Call AdvReplaceInFile
 	
 	#-- �滻����·�� --#
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
  
  #-- �޸�php.ini�ļ� --#
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
  
  #-- �滻����·�� --#
  Push C:\www\tools #text to be replaced
	Push $INSTDIR #replace with
	Push all #replace all occurrences
	Push all #replace all occurrences
	Push $INSTDIR\memcached\install.bat #file to replace in
 	Call AdvReplaceInFile
 	
  #-- �滻����·�� --#
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

Section "orcle�ͻ���" oracle_client
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

Section "sqlsrv�ͻ���������װ��" sqlsrv
  SetOutPath "$INSTDIR\setup\sqlsrv_client_setup"
  File /r "src\setup\sqlsrv_client_setup\*.*"
SectionEnd

Section "visual c++��װ��" vs
  SetOutPath "$INSTDIR\setup\vs_setup"
  File /r "src\setup\vs_setup\*.*"
SectionEnd

Section "redis��װ��" redis
  
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
  
  #-- �滻·�� --#
  Push C:\www\websoft #text to be replaced
	Push $INSTDIR #replace with
	Push all #replace all occurrences
	Push all #replace all occurrences
	Push $INSTDIR\database\mysql-5.7.18\mysql\install.bat #file to replace in
 	Call AdvReplaceInFile
 	
 	#-- �滻·�� --#
  Push C:\www\websoft #text to be replaced
	Push $INSTDIR #replace with
	Push all #replace all occurrences
	Push all #replace all occurrences
	Push $INSTDIR\database\mysql-5.7.18\mysql\uninstall.bat #file to replace in
 	Call AdvReplaceInFile
 	
	#-- ��������Ŀ¼ --#
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

#-- ���� NSIS �ű��༭�������� Function ���α�������� Section ����֮���д���Ա��ⰲװ�������δ��Ԥ֪�����⡣--#

; �����������
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${main} "�������ѡ"
  !insertmacro MUI_DESCRIPTION_TEXT ${phpmyadmin} "mysqlweb����ϵͳ"
  !insertmacro MUI_DESCRIPTION_TEXT ${kodexplorer} "â����-��Դ������"
  !insertmacro MUI_DESCRIPTION_TEXT ${nginx} "nginx-1.10.3 ������װ�ű��������رսű�"
  !insertmacro MUI_DESCRIPTION_TEXT ${Apache} "Apache2.4.25 vc11����"
  !insertmacro MUI_DESCRIPTION_TEXT ${php5.6.29} "php5.6.29 vc11 64λ����"
  !insertmacro MUI_DESCRIPTION_TEXT ${php7.0.15} "php7.0.15 vc14 64λ����"
  !insertmacro MUI_DESCRIPTION_TEXT ${php7.1.1} "php7.1.1 vc14 64λ���� ��֧��memcached"
  !insertmacro MUI_DESCRIPTION_TEXT ${memcached} "memcached��������memcached����ϵͳ"
  !insertmacro MUI_DESCRIPTION_TEXT ${memadmin} "memcached����ϵͳ"
  !insertmacro MUI_DESCRIPTION_TEXT ${oracle_client} "php����oracle��Ҫ������"
  !insertmacro MUI_DESCRIPTION_TEXT ${tools} "�����˿ڲ��Խű����ı��༭����ɫ��"
  !insertmacro MUI_DESCRIPTION_TEXT ${sqlsrv} "�������microsoft sql server 2008 native client��Microsoft? ODBC Driver 13 for SQL Serve"
  !insertmacro MUI_DESCRIPTION_TEXT ${vs} "Apache��php5.6��Ҫvc11��֧�֣�php7��Ҫvc14��֧��"
  !insertmacro MUI_DESCRIPTION_TEXT ${redis} "redis3.2 no sql �� redis����ϵͳ"
  !insertmacro MUI_DESCRIPTION_TEXT ${redisadmin} "redis����ϵͳ"
  !insertmacro MUI_DESCRIPTION_TEXT ${mysql5.7.18} "mysql5.7.18"
!insertmacro MUI_FUNCTION_DESCRIPTION_END

/******************************
 *  �����ǰ�װ�����ж�ز���  *
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
  Delete "$INSTDIR\ʹ��˵��.txt"

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


#-- ���� NSIS �ű��༭�������� Function ���α�������� Section ����֮���д���Ա��ⰲװ�������δ��Ԥ֪�����⡣--#

Function un.onInit
	Call un.CreateMutex
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "��ȷʵҪ��ȫ�Ƴ� $(^Name) ���������е������" IDYES +2
  Abort
FunctionEnd

Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) �ѳɹ��ش����ļ�����Ƴ���"
FunctionEnd

#-- �滻�ļ����ݺ��� --#

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
#��鰲װ���⣺#
ReCheck:
  System::Call 'kernel32::CreateMutexA(i 0, i 0, t "${MyMutex_Install}") i .R1 ?e'
Pop $R0
  System::Call 'kernel32::CloseHandle(i R1) i.s'
#���ж�ػ��⣺#
  System::Call 'kernel32::CreateMutexA(i 0, i 0, t "${MyMutex_UnInstall}") i .R3 ?e'
Pop $R2
  System::Call 'kernel32::CloseHandle(i R3) i.s'
#�жϰ�װ/ж�ػ���Ĵ���#
${If} $R0 != 0
  MessageBox MB_RetryCancel|MB_ICONEXCLAMATION "��װ�����Ѿ����У�" IdRetry ReCheck
Quit
${ElseIf} $R2 != 0
  MessageBox MB_RetryCancel|MB_ICONEXCLAMATION "ж�س����Ѿ����У�" IdRetry ReCheck
Quit
${Else}
#������װ���⣺#
  System::Call 'kernel32::CreateMutexA(i 0, i 0, t "${MyMutex_Install}") i .R1 ?e'
Pop $R0
  StrCmp $R0 0 +2
Quit
${EndIf}
FunctionEnd

Function Un.CreateMutex
#��鰲װ���⣺#
ReCheck:
  System::Call 'kernel32::CreateMutexA(i 0, i 0, t "${MyMutex_Install}") i .R1 ?e'
Pop $R0
  System::Call 'kernel32::CloseHandle(i R1) i.s'
#���ж�ػ��⣺#
CheckUnInstall:
  System::Call 'kernel32::CreateMutexA(i 0, i 0, t "${MyMutex_UnInstall}") i .R3 ?e'
Pop $R2
  System::Call 'kernel32::CloseHandle(i R3) i.s'
#�жϰ�װ/ж�ػ���Ĵ���#
${If} $R0 != 0
  MessageBox MB_RetryCancel|MB_ICONEXCLAMATION "��װ�����Ѿ����У�" IdRetry ReCheck
Quit
${ElseIf} $R2 != 0
  MessageBox MB_RetryCancel|MB_ICONEXCLAMATION "ж�س����Ѿ����У�" IdRetry ReCheck
Quit
${Else}
#����ж�ػ��⣺#
  System::Call 'kernel32::CreateMutexA(i 0, i 0, t "${MyMutex_UnInstall}") i .R1 ?e'
Pop $R0
  StrCmp $R0 0 +2
Quit
${EndIf}
FunctionEnd

