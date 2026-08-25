@echo off
setlocal enabledelayedexpansion
REM ============================================================
REM run_task.bat
REM Trinity Sales Register — download + email, no WhatsApp.
REM Registered in Windows Task Scheduler to run daily at 7:00 AM.
REM Retries since the ERP login/page-load is flaky (no one watching).
REM ============================================================

cd /d "%~dp0"
set LOGFILE=run_log.txt
set MAX_ATTEMPTS=6

echo [%DATE% %TIME%] Starting Trinity Sales Register (download + email)... >> "%LOGFILE%"

for /L %%A in (1,1,%MAX_ATTEMPTS%) do (
    echo [%DATE% %TIME%] Download attempt %%A of %MAX_ATTEMPTS%... >> "%LOGFILE%"
    python automate_report.py >> "%LOGFILE%" 2>&1
    if !ERRORLEVEL! EQU 0 (
        echo [%DATE% %TIME%] Download completed successfully on attempt %%A. >> "%LOGFILE%"
        goto :download_done
    )
    echo [%DATE% %TIME%] Download attempt %%A failed with error code !ERRORLEVEL!. >> "%LOGFILE%"
)

echo [%DATE% %TIME%] All %MAX_ATTEMPTS% download attempts failed. >> "%LOGFILE%"
goto :done

:download_done
echo [%DATE% %TIME%] Emailing downloaded Sales Register (no edits)... >> "%LOGFILE%"
python email_sender.py >> "%LOGFILE%" 2>&1
if !ERRORLEVEL! EQU 0 (
    echo [%DATE% %TIME%] Email sent. >> "%LOGFILE%"
) else (
    echo [%DATE% %TIME%] Email FAILED with error code !ERRORLEVEL!. >> "%LOGFILE%"
)

:done
