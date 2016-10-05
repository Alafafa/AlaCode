@echo off
title AlaSS_script_console

if "%alasPswdSub%" == "" (
	echo please set env var alasPswdSub first.
	goto eof
)
set szDateTime=%DATE:~0,2%%DATE:~3,2%%DATE:~6,2%%TIME:~0,2%%TIME:~3,2%%TIME:~6,2%

if exist .\AlaSale.7z (
	if exist .\AlaSale.xls (
		echo AlaSale.xls file exists, rename it automatically!!!
		rem if exist .\AlaSale.7z.old (
		rem	echo AlaSale.xls.old exists, delete it automatically!!!
		rem	del .\AlaSale.xls.old
		rem )
		
		echo rename AlaSale.xls AlaSale.%szDateTime%.xls

		rename AlaSale.xls AlaSale.%szDateTime%.xls
	)
	7z x -p%alasPswdSub% .\AlaSale.7z
)

:eof
echo. && echo press any key to quit. && pause>nul