:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: DMS	   :	Auto-Launch Nodel Process Node                         ::
:: VERSION :    2.0                                                    ::
:: EDIT    :	15.02.2019                                             ::
:: INFO	   :	Launch and maintain the nodel.                         ::
:: USE	   :	Load nodel and set no-right-click & kiosk on start-up. ::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

@echo off
setlocal EnableExtensions

:: Variables
set exe=java.exe
set norightclick=C:/Utilities/NoRightClick.exe
set taskkill=taskkill /f /im explorer.exe >nul

:: Process Node startup
:Startup
c:
cd c:\nodel\
start /min java -jar nodel.jar

:: Setup kiosk mode.
:Kiosk
:: Remove rem below to disable Explorer
rem start %taskkill%

:: Remove rem below to disable right click
rem start %norightclick%

:: Executable is running. Wait 60 second, and check again.
:Running
echo Checking if program is running...
timeout /t 10
cls
FOR /F %%x IN ('tasklist /NH /FI "IMAGENAME eq %EXE%"') DO IF %%x == %EXE% goto running
goto Startup