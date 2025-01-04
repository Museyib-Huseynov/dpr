@echo off
setlocal enabledelayedexpansion
set /p folder="Please enter the folder name: "
set "folder=!folder:\=\\!"
node dpr.js "!folder!"
pause
