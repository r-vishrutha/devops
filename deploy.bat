@echo off
REM Set paths
set SOURCE_DIR=%~dp0build
set DEST_DIR=C:\ReactDeploy

REM Ensure build exists
if not exist "%SOURCE_DIR%" (
  echo Build directory not found. Please run npm run build first.
  exit /b 1
)

REM Create deploy directory if not exists
if not exist "%DEST_DIR%" (
  mkdir "%DEST_DIR%"
)

REM Clear old deployment
del /Q "%DEST_DIR%\*"
for /d %%x in ("%DEST_DIR%\*") do rmdir /s /q "%%x"

REM Copy new build files
xcopy /E /I /Y "%SOURCE_DIR%\*" "%DEST_DIR%\"

echo Deployment complete.
