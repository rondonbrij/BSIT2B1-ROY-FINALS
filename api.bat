@echo off

start "Customer Management System" cmd /k "python api_finals.py"

echo.
echo   _____         __                       ________  __  _____ 
echo  / ___/_ _____ / /____  __ _  ___ ____  / ___/ _ \/ / / / _ \
echo / /__/ // ^(_-^</ __/ _ \/  ' \/ -_^) __/ / /__/ , _/ /_/ / // /
echo \___/\_,_/___/\__/\___/_/_/_/\__/_/    \___/_/^|_^|\____/____/ 
echo.


curl http://127.0.0.1:5000
set /p choice=Enter your choice (1-4 or e): 

if "%choice%"=="1" (
	cls
	goto add
) else if "%choice%"=="2" (
	cls
	goto retrieve
) else if "%choice%"=="3" (
	cls
	goto update
) else if "%choice%"=="4" (
	cls
	goto delete
) else if "%choice%"=="e" (
	cls
	goto end
)


:add
:retrieve
:update
:delete
:end