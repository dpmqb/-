@echo off
net.exe session 1>NUL 2>NUL && (goto as_admin) || (goto not_admin)
:as_admin
setlocal enabledelayedexpansion
if "%~1" equ "" (goto filetemp) else (goto readpath)
:filetemp
for /f "tokens=1-5 delims=?" %%i in (%temp%\dism_temp.log) do (
set filepath=%%i
set lujing=%%j
set filename=%%k
set attribute=%%l
set tuozhan=%%m
)
del /q "%temp%\dism_temp.log"
goto dirorfile
:readpath
set filepath=%~1
set lujing=%~dp1
set filename=%~n1
set attribute=%~a1
set tuozhan=%~x1
goto dirorfile
:dirorfile
cd /d c:\
if /i "%attribute:~0,1%" equ "d" goto file
if /i "%tuozhan%" equ ".wim" goto image
if /i "%tuozhan%" equ ".esd" goto image
else
goto end
:not_admin
echo %~1?%~dp1?%~n1?%~a1?%~x1>"%temp%\dism_temp.log"
set /p f=<"%temp%\dism_temp.log"
if "%f%" equ "????" (
mode con cols=78 lines=10&color 3F
echo.
echo 	Dism����˵����
echo ��1����.wim.esd��׺ӳ���ļ����������ļ�����ק����������
echo ��2�����ݹ��ܼ�����Ų��س�������q���س����˳�����
echo.
echo 	ע��
echo ��1����ȡ�����ӳ��recoveryѹ�������.esdӳ���ļ������Ĵ�����ʱ���Լ����ܣ�
echo ��2���������޷��������ƴ��С�^&�����ŵ��ļ����ļ��С�
echo.
pause
exit
)
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
"%temp%\getadmin.vbs"
exit /B
:file
set which=0
echo ��1��ж�ش��ļ��е�ӳ���ļ�
echo ��2��������ļ��е�ӳ���ļ�
echo.
echo q���س����˳�����
echo.
set /p which=��%filename%�ļ���ִ��ʲô������
if "%which%" equ "1" goto unmount
if "%which%" equ "2" goto capture
if /i "%which%" equ "q" goto end
else (
cls
goto file
)
:unmount
echo commit���������Ĳ�ж��
echo discard������������ֱ��ж��
set /p save=�Ƿ�������:
Dism /Unmount-Wim /Mountdir:%filepath% /%save% || (goto unmountUnsuccessful)
set save=
rd %filepath%
pause
exit
:unmountUnsuccessful
set save=
pause
cls
goto file
:capture
set /p name=�����ӳ���ļ����ӳ������ƣ�
set /p description=�����ӳ���ļ����ӳ���������
echo none����ѹ��ֱ�Ӵ洢
echo fast����ѹ����洢
echo max�����ѹ����洢
set /p compress=�����ӳ���ļ���ѹ����ʽ��
if /i exist "%filepath%_%compress%.wim" (
echo ��%filename%%tuozhan%_%compress%.wimӳ���ļ�ͬ������������ֹ��
) else (
Dism /Capture-Image /ImageFile:%filepath%_%compress%.wim /CaptureDir:%filepath% /Name:%name% /Description:%description% /Compress:%compress%
)
set name=
set description=
set compress=
pause
cls
goto file
:image
set which=0
echo ��1���鿴��ӳ���ļ�������Ϣ
echo ��2���Ӵ�ӳ���ļ�����ȡӳ������ӳ���ļ�
echo ��3������ӳ����
if /i "%tuozhan%" equ ".wim" (echo ��4������ӳ�����)
echo.
echo q���س����˳�����
echo.
set /p which=��%filename%%tuozhan%ӳ���ļ�ִ��ʲô������
if "%which%" equ "1" goto information
if "%which%" equ "2" goto export
if "%which%" equ "3" goto apply
if /i "%tuozhan%" equ ".wim" (if "%which%" equ "4" goto mount)
if /i "%which%" equ "q" goto end
else (
cls
goto image
)
:information
Dism /Get-Wiminfo /Wimfile:%filepath%
pause
cls
goto image
:export
set /p sourceIndex=��ȡ��ӳ��������ţ�
set /p tofilename=��ȡ��������ӳ���ļ����ļ���������.wim��.sed��׺����
set /p name=���浽����ӳ���ļ����ӳ������ƣ�
if not "%name%" equ "" (set name= /DestinationName:"!name!")
if not exist %lujing%%tofilename% (
echo none����ѹ��ֱ�Ӵ洢
echo fast����ѹ����洢
echo max�����ѹ����洢
echo recovery������ѹ����洢����׺ӦΪ.esd��
set /p compress=��ȡ��������ӳ���ļ���ѹ����ʽ��
set compress= /Compress:!compress!
)
Dism /Export-Image /SourceImageFile:%filepath% /SourceIndex:%sourceIndex% /DestinationImageFile:%lujing%%tofilename%%name%%compress%
set sourceIndex=
set tofilename=
set name=
set compress=
pause
cls
goto image
:mount
if not exist "%lujing%����%filename%\" (
md "%lujing%����%filename%"
) else (
echo ��ͬ���ļ���"����%filename%"����������ֹ��
goto mountend
)
set /p sourceIndex=���ص�ӳ��������ţ�
Dism /Mount-Wim /Wimfile:%filepath% /Index:%sourceIndex% /Mountdir:%lujing%����%filename% || (rd "%lujing%����%filename%")
set sourceIndex=
:mountend
pause
cls
goto image
:apply
if not exist "%lujing%����%filename%\" (
md "%lujing%����%filename%"
) else (
echo ��ͬ���ļ���"����%filename%"����������ֹ��
goto applyend
)
set /p sourceIndex=�����ӳ��������ţ�
Dism /Apply-Image /ImageFile:%filepath% /Index:%sourceIndex% /ApplyDir:%lujing%����%filename% || (rd "%lujing%����%filename%")
set sourceIndex=
:applyend
pause
cls
goto image
:end
