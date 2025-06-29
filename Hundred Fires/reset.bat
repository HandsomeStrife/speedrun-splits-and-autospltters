@echo off
echo Registry Cleanup Script
echo =======================
echo.
echo This script will clear all registry values in:
echo HKEY_CURRENT_USER\Software\davidamado
echo.

REM Check if the registry key exists first
reg query "HKEY_CURRENT_USER\Software\davidamado" >nul 2>&1
if %errorlevel% neq 0 (
    echo Registry key does not exist. Nothing to clean.
    echo.
    pause
    exit /b 0
)

echo Registry key found. Proceeding with cleanup...
echo.

REM Delete all values under the key (but keep the key structure)
reg delete "HKEY_CURRENT_USER\Software\davidamado" /va /f >nul 2>&1
if %errorlevel% equ 0 (
    echo SUCCESS: All registry values have been cleared.
) else (
    echo ERROR: Failed to clear registry values. You may need administrator privileges.
)

echo.
echo Cleanup complete.
pause
