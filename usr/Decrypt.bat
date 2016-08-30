@echo off
if exist .\AlaSale.7z (
	if exist .\AlaSale.xls (
		echo AlaSale.xls file exists, delete it automatically!!!
		del .\AlaSale.xls
	)
	7z x -p%alasPswdSub% .\AlaSale.7z
)

echo. && echo press any key to quit. && pause>nul