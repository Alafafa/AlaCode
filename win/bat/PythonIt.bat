@echo off
title Python运行工具 -- Powered_by_SindoSoft

if "%PYTHON_ROOT%" == "" (
	set PYTHON_ROOT=D:\SomeApps\Python\Python2.7
)
set PATH=%PATH%;"%PYTHON_ROOT%\";"%PYTHON_ROOT%\DLLs"

if "%1" == "" (
	cmd
)
if not "%1" == "" (
	python %1 %2 %3 %4 %5 %6 %7 %8 %9
	echo.
	pause
)