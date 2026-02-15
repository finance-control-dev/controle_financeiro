@echo off
setlocal enabledelayedexpansion

echo ==========================================
echo   Financial Control - Project Setup
echo ==========================================

REM 1. Check if flutter is already in PATH
where flutter >nul 2>nul
if %errorlevel% equ 0 (
    echo [CHECK] Flutter found in global PATH.
    goto :run_create
)

echo [INFO] Flutter not found in global PATH. 
echo [INFO] Searching common locations...

REM 2. Define common paths to search
set "COMMON_PATHS=C:\src\flutter\bin;C:\flutter\bin;%USERPROFILE%\flutter\bin;%LOCALAPPDATA%\flutter\bin;D:\src\flutter\bin;D:\flutter\bin;C:\Program Files\flutter\bin"

REM 3. Loop through paths
for %%p in ("%COMMON_PATHS:;=" "%") do (
    if exist "%%~p\flutter.bat" (
        echo [FOUND] Flutter found at: %%~p
        set "PATH=%PATH%;%%~p"
        goto :run_create
    )
)

REM 4. If not found, ask user
echo.
echo [ERROR] Could not auto-detect Flutter SDK.
echo Please enter the full path to your 'flutter\bin' folder.
echo Example: C:\src\flutter\bin
echo.
set /p FLUTTER_PATH=Path: 

if exist "%FLUTTER_PATH%\flutter.bat" (
    set "PATH=%PATH%;%FLUTTER_PATH%"
    goto :run_create
) else (
    echo [ERROR] Invalid path or flutter.bat not found.
    echo Please install Flutter and try again.
    pause
    exit /b 1
)

:run_create
echo.
echo [ACTION] Generatig Android and iOS platform files...
call flutter create . --project-name=financial_control

echo.
echo [ACTION] Installing dependencies...
call flutter pub get

echo.
echo ==========================================
echo   Setup Complete!
echo ==========================================
echo.
echo 1. Android and iOS folders have been created.
echo 2. Add 'google-services.json' to 'android/app/'.
echo 3. Add 'GoogleService-Info.plist' to 'ios/Runner/'.
echo 4. Run 'flutter run'.
echo.
pause
