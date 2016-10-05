@echo off
title AlaSS_script_console

if "%alasPswdSub%" == "" (
	echo please set env var alasPswdSub first.
	goto eof
)
if exist .\AlaSale.xls (
	if exist .\AlaSale.7z (
		echo AlaSale.7z file exists, delete it automatically!!!
		del .\AlaSale.7z
	)
	7z a -p%alasPswdSub% .\AlaSale.7z .\AlaSale.xls
)

:eof

echo. && echo press any key to quit. && pause>nul