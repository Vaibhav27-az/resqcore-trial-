@echo off
title Tactical Field Ops App (RescueApp) - Port 8082
cd /d "%~dp0RescueApp"

echo ===================================================================
echo   ResQCore - Tactical Field Operations Mobile/Web App
echo   Local Server: http://localhost:8082
echo   Backend Hub:  http://localhost:5000
echo ===================================================================
echo.
echo [1] Opening Tactical App in default browser (http://localhost:8082)...
timeout /t 1 /nobreak >nul
start http://localhost:8082

echo [2] Starting local web server on port 8082...
node serve.js
pause
