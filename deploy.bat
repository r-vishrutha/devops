@echo off
REM ================================
REM React App Deployment Script
REM ================================

REM Set source (React build) and destination directories
set SOURCE_DIR=%~dp0build
set DEST_DIR=C:\ReactDeploy

REM Check if build directory exists
if not exist "%SOURCE_DIR%" (
    echo ❌ Build directory not found. Please run "npm run build" first.
    exit /b 1
)

REM Create deployment directory if it doesn't exist
if not exist "%DEST_DIR%" (
    mkdir "%DEST_DIR%"
)

REM Clear old deployment files
echo 🔄 Clearing old deployment...
del /Q "%DEST_DIR%\*"
for /d %%x in ("%DEST_DIR%\*") do rmdir /s /q "%%x"

REM Copy new build files to destination
echo 📦 Copying new build files...
xcopy /E /I /Y "%SOURCE_DIR%\*" "%DEST_DIR%\"

echo ✅ Deployment complete. Files are now in "%DEST_DIR%"
