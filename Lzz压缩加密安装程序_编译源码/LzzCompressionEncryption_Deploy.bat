@echo off
title Lzzѹ�����ܰ�װ����
mode con cols=50 lines=10&color 3F
net.exe session 1>NUL 2>NUL && (goto as_admin) || (goto not_admin)
:not_admin
echo.
echo 	���밲װ·���������뼴��װ��Ĭ��Ŀ¼����
set /p installdir=	����ק��װĿ¼���˴���
if "%installdir%" equ "" goto up
if "%installdir:~-2%" equ ":\" set installdir=%installdir:~-0,2%
if not exist "%installdir%\" (
echo.
echo 	��Ч��Ŀ¼��
echo 	�����¼��룡
echo.
set installdir=
pause
cls
goto not_admin
) else (
echo %installdir%>"%temp%\installdir.lce"
)
:up
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
"%temp%\getadmin.vbs"
exit /B
:as_admin
if exist "%temp%\installdir.lce" (
set /p installdir=<"%temp%\installdir.lce"
del /q "%temp%\installdir.lce"
) else (
echo.
echo 	���Զ���װ��Ĭ��Ŀ¼��
echo.
pause
set installdir=%ProgramFiles%
)
md "%installdir%\Lzz Compression Encryption\" 1>NUL 2>NUL
copy /y "LzzCompressionEncryption.exe" "%installdir%\Lzz Compression Encryption\" 1>NUL 2>NUL
copy /y "Uninstall.exe" "%installdir%\Lzz Compression Encryption\" 1>NUL 2>NUL
ASSOC .Lzz=LvZhenzong 1>NUL 2>NUL
FTYPE LvZhenzong="%installdir%\Lzz Compression Encryption\LzzCompressionEncryption.exe" %1 1>NUL 2>NUL
str "LzzCompressionEncryptionInstallation.reg" 0 0 /R /asc:"LCEDir" /asc:"%installdir:\=\\%" /A
regedit /s LzzCompressionEncryptionInstallation.reg
exit
