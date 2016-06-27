@ECHO OFF
setlocal enabledelayedexpansion

REM ===============[ Main Menu ]===============
:Menu
CLS
Color 0A
Echo.
Echo.
Echo  Windows Wifi Profile Viewer
Echo  ==================================
Echo.
Echo   Select Operation:
Echo.
Echo    1^> View Wifi profiles.
Echo    2^> Export All Profiles to separate files.
Echo    3^> Exit
Echo.
SET "cho="
SET /P "cho=   Select: "
IF /I "%cho%" == "1" Goto :VProfile
IF /I "%cho%" == "2" Goto :ExportPro
IF /I "%cho%" == "3" Goto :EOF
CLS
Color 0C
Echo.&Echo.&Echo.&Echo   Error! , No Such Option.
Ping Localhost -n 4 >NUL
GOTO :Menu

REM ===============[ /Main Menu ]===============

REM ===============[ View Profiles ]===============

:VProfile
CLS
Color 0A
Set i=1
for /f "skip=9 tokens=1-4* delims= " %%A in ('netsh wlan show profile') Do (
	SET "Line=%%A %%B %%C %%D %%E"
	SET array[!i!]=%%E
	SET /a i+=1
)
set n=%i%

SET /a UBound=i-1
Echo  ==================================
Echo.
Echo   Select WiFi Profile:
Echo.
Echo  ==================================
for /l %%i in (1,1,%UBound%) Do (
    echo     %%i^>. !array[%%i]!
)
Echo  ==================================
Echo.
echo     m^>. Return to main menu
echo     x^>. Exit
Echo.
Echo  ==================================

SET /P "i=   Select: "
for /L %%i in (%i%,1,%i%) Do (
    echo !array[%%i]! > %temp%\wlan_name
		netsh wlan show profile name="!array[%%i]!" key="clear" |find "Key Content" >> %temp%\wlan_pass
)
IF /I "%i%" == "m" Goto :Menu
IF /I "%i%" == "x" Goto :EOF

for /F %%h in ('type "%temp%\wlan_name"') do set wlan=%%h
for /F "tokens=3 delims=: " %%g in ('type "%temp%\wlan_pass"') do set wpass=%%g


cls

echo ===================================
echo Selected Network: %wlan%
echo Password        : %wpass%
echo ===================================
echo.
echo.
echo What would you like to do next?
echo.
Echo    1^> Save to File.
Echo    2^> Return to main menu.
Echo    3^> Exit.
SET "cho="
SET /P "cho=   Select: "
IF /I "%cho%" == "1" Goto :SProfile
IF /I "%cho%" == "2" Goto :Menu
IF /I "%cho%" == "3" Goto :EOF
CLS
Color 0C
Echo.&Echo.&Echo.&Echo  Error! , No Such Option.
Ping Localhost -n 4 >NUL
Goto :VProfile





REM ===============[ Save to Text File ]===============
:SProfile
CLS
Color 0A
set mydir="C:\Wlan"
IF not exist %mydir% (mkdir "%mydir%")
Echo ===================================
Echo Text file will be saved to C:\Wlan\%wlan%-Wlan.txt by default
Echo ===================================
echo =================================== > C:\Wlan\%wlan%-Wlan.txt
echo Selected Network: %wlan% >> C:\Wlan\%wlan%-Wlan.txt
echo Password        : %wpass% >> C:\Wlan\%wlan%-Wlan.txt
echo =================================== >> C:\Wlan\%wlan%-Wlan.txt
Echo Details have been saved.
Echo ===================================
Goto :Menu

REM ===============[ Export AlL Profiles ]===============
:ExportPro
set mydir="C:\Wlan"
IF not exist %mydir% (mkdir "%mydir%")
cd C:\Wlan
del *.txt
del *.xml
netsh wlan export profile key=clear >NUL
ren *.xml *.txt
Goto :Message

:Message
CLS
Color 0A
Echo Exporting Profiles.
Echo [==        ]
Ping Localhost -n 2 >NUL
CLS
Echo Exporting Profiles..
Echo [====      ]
Ping Localhost -n 2 >NUL
CLS
Echo Exporting Profiles...
Echo [======    ]
Ping Localhost -n 2 >NUL
CLS
Echo Exporting Profiles.
Echo [========  ]
Ping Localhost -n 2 >NUL
CLS
Echo Exporting Profiles..
Echo [==========]
Ping Localhost -n 4 >NUL
CLS
Echo ===================================
Echo All profiles Exported Sucessfully
Echo Profiles can be found at %mydir%
Echo Returning to main menu
Echo ===================================
Ping Localhost -n 4 >NUL
explorer %mydir%
Goto :Menu
Pause
