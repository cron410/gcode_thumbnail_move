@echo off
setlocal enabledelayedexpansion

if "%~1"=="" (
    echo Usage: move_thumbnail_block.bat input_file
    exit /b 1
)

set "inputFile=%~1"
set "backupFile=%inputFile%.bak"
copy /Y "%inputFile%" "%backupFile%" >nul

set "startIndex=-1"
set "endIndex=-1"

for /f "delims=" %%i in ('findstr /n "^" "%inputFile%"') do (
    set "line=%%i"
    set "lineContent=!line:*:=!"

    rem Check for THUMBNAIL_BLOCK_START
    if not "!startIndex!"=="-1" (
        echo !lineContent! | findstr /c:"; THUMBNAIL_BLOCK_END" >nul && (
            set /a endIndex=!line:0,1!            
            goto :process
        )
    ) else (
        echo !lineContent! | findstr /c:"; THUMBNAIL_BLOCK_START" >nul && (
            set /a startIndex=!line:0,1!
        )
    )
)

echo Thumbnail block not found in the input file
exit /b

:process
(for /f "usebackq delims=" %%a in ("%inputFile%") do (
    set "line=%%a"
    set "currentIndex=!line:~0,-1!"
    rem Skip thumbnail block
    if !currentIndex! lss !startIndex! (
        echo !line!
    )
    if !currentIndex! gtr !endIndex! (
        echo !line!
    )
)
rem Now append the thumbnail block at the end
(for /f "usebackq skip=%startIndex% tokens=*" %%b in ("%inputFile%") do (
    if %%B geq %startIndex% if %%B leq %endIndex% echo %%b
))) > "%inputFile%"

endlocal
