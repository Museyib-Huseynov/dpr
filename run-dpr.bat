@echo off
setlocal enabledelayedexpansion
set /p folder="Please enter the folder name: "
if not "!folder!"=="" (
    set "folder=!folder:\=\\!"
)
node dpr_v2.js "!folder!"
pause

