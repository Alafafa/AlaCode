@echo off
if exist .\AlaSale.7z (
	if exist .\AlaSale.xls (
		echo AlaSale.xls file exists, rename it automatically!!!
		if exist .\AlaSale.7z.old (
			echo AlaSale.xls.old exists, delete it automatically!!!
			del .\AlaSale.xls.old
		)
		rename .\AlaSale.xls .\AlaSale.xls.old
	)
	7z x -p%alasPswdSub% .\AlaSale.7z
)

echo. && echo press any key to quit. && pause>nul