@echo off
title ���ӹ���
cd /d %~dp0
net.exe session 1>NUL 2>NUL && (goto as_admin) || (goto not_admin)
:as_admin
mode con cols=64 lines=5&color 3F
setlocal enabledelayedexpansion
for /f "tokens=1,2 delims=?" %%i in (%temp%\linkbat_temp.log) do (
set linkpath=%%i
set attribute=%%j
)
if /i "%attribute:~0,1%" equ "d" (goto d) else (goto f)
:not_admin
mode con cols=50 lines=13
echo %~1?%~a1>"%temp%\linkbat_temp.log"
set /p f=<"%temp%\linkbat_temp.log"
if "%f%" equ "?" (
echo.
echo 	���ӹ���˵����
echo ��1�������������ΪҪ�����������ӵ�����
echo ��2�������������Ҫ���������������ڵ�Ŀ¼
echo ��3���������������õ�Ŀ¼���ļ���ק��������
echo ��4������ѡ�����ӷ�ʽ��ΪĿ¼���ļ�����������
echo.
echo 	ע��
echo ��1�����̷�Ϊ�ļ���������ʱ���Զ������������ӡ�
echo ��2��ΪSMB�ļ���Ŀ¼��������ʱ���Զ������������ӡ�
echo.
pause
exit
)
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
"%temp%\getadmin.vbs"
exit /B
:d
if /i "%linkpath:~0,2%" equ "\\" (
set way=d
) else (
echo.
echo 	�ڱ�����Ŀ¼�£�Ϊ�ļ��д����������������룺D
echo 	�ڱ�����Ŀ¼�£�Ϊ�ļ��д���Ŀ¼���������룺J
echo.
set /p way=�����루d/j����
)
if /i "%way%" equ "d" (mklink /d "%~dpn0" "%linkpath%" 1>NUL 2>NUL)
if /i "%way%" equ "j" (mklink /j "%~dpn0" "%linkpath%" 1>NUL 2>NUL)
exit
:f
if /i "%linkpath:~0,2%" equ "\\" (goto w)
if /i "%linkpath:~0,2%" equ "%~d0" (
echo.
echo 	�ڱ�����Ŀ¼�£�Ϊ�ļ������������������룺D
echo 	�ڱ�����Ŀ¼�£�Ϊ�ļ�����Ӳ���������룺H
echo.
set /p way=�����루d/h����
goto fhd
) else (
:w
set way=d
goto fd
)
:fhd
if /i "%way%" equ "h" (mklink /h "%~dpn0" "%linkpath%" 1>NUL 2>NUL)
:fd
if /i "%way%" equ "d" (mklink "%~dpn0" "%linkpath%" 1>NUL 2>NUL)
exit
