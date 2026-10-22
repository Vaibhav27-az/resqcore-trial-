@echo off
title Citizen Emergency App (RescueCoreF) - Port 8081
cd /d "%~dp0RescueCoreF"

echo ===================================================================
echo   ResQCore - Citizen Emergency Response Mobile/Web App
echo   Local Server: http://localhost:8081
echo   Backend Hub:  http://localhost:5000
echo ===================================================================
echo.
echo [1] Opening Citizen App in default browser (http://localhost:8081)...
timeout /t 1 /nobreak >nul
start http://localhost:8081

echo [2] Starting local web server on port 8081...
node serve.js
pause
