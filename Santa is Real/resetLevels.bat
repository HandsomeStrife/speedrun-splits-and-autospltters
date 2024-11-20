@echo off
REM Define the registry path
set "regPath=HKEY_CURRENT_USER\Software\unitedvirtualassets\Santa is Real"

REM Search for the value name containing "achieved_level"
for /f "tokens=1,2,* delims= " %%A in ('reg query "%regPath%" ^| findstr "achieved_level"') do (
    set "valueName=%%A"
)

REM Check if the value name was found
if not defined valueName (
    echo No value containing "achieved_level" was found in the registry.
    pause
    exit /b
)

REM Confirm the detected value name
echo Found registry value: %valueName%

REM Set the value of the registry entry to 0 (decimal)
reg add "%regPath%" /v %valueName% /t REG_DWORD /d 0 /f

REM Verify if the value was set correctly
reg query "%regPath%" /v %valueName% | findstr "0x0" >nul && (
    echo Registry value was successfully set to 0.
    pause
    exit /b
)

echo Failed to update the registry value.
pause
exit /b
