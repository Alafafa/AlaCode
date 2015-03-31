@echo off

set antFile=-f %1.xml
if "%1"==""  goto help

set antTarget=-DargTarget=%2
if "%2"==""  set antTarget=-DargTarget=main

set antShadowName=-DargShadowName=%3
if "%3"==""  set antShadowName=

echo ant.bat %antFile% %antTarget% %antShadowName%
call ant.bat %antFile% %antTarget% %antShadowName%

echo SsRunAnt.bat finished!!!!!!
goto eof

:help
echo +++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo +  ÓÃ·¨: %0 antFile antTarget antShadowName
echo +++++++++++++++++++++++++++++++++++++++++++++++++++++++

:eof