@echo off
title ResQCore Unified Emergency Hub Backend - Port 5000
cd /d "%~dp0backend"

echo ===================================================================
echo   Starting ResQCore Unified Disaster Response Backend Hub
echo   Port: 5000 (REST API + WebSocket /ws)
echo   Also serving Citizen App on :8081 and Tactical Ops on :8082
echo ===================================================================
echo.
timeout /t 2 /nobreak >nul
start http://localhost:5000

node server.js
pause
