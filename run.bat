call build.bat

if not errorlevel 1 (
	C:\Dev\ZXNext\bin\hdfmonkey put C:\Dev\ZXNext\sdcard\cspect-next-2gb.img main.nex
	@REM C:\Dev\ZXNext\bin\hdfmonkey put C:\Dev\ZXNext\sdcard\cspect-next-2gb.img main.nex
	C:\Dev\ZXNext\bin\CSpect.exe -r -brk -zxnext -nextrom -tv -basickeys -vsync -sound -mmc=C:\Dev\ZXNext\sdcard\cspect-next-2gb.img
)
else(
PAUSE
)