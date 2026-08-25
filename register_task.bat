@echo off
REM ============================================================
REM register_task.bat
REM Registers run_task.bat in Windows Task Scheduler to run daily
REM at 7:00 AM. Runs under the SYSTEM account (no password needed,
REM works even when no user is logged on).
REM
REM Run this ONCE as Administrator.
REM Edit the /ST time or /TN name below if needed.
REM ============================================================

setlocal
set TASK_NAME=Trinity Sales Register Email
set BAT_PATH=%~dp0run_task.bat

schtasks /Create ^
 /TN "%TASK_NAME%" ^
 /TR "%BAT_PATH%" ^
 /SC DAILY ^
 /ST 07:00 ^
 /RU SYSTEM ^
 /RL HIGHEST ^
 /F

if %ERRORLEVEL% EQU 0 (
    echo.
    echo Task "%TASK_NAME%" scheduled daily at 07:00 (SYSTEM account).
    echo Verify with:  schtasks /Query /TN "%TASK_NAME%"
) else (
    echo.
    echo Failed to create the task. Run this .bat as Administrator.
)
pause
