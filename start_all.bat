@echo off
title ResQCore - Run All Connected Together
cd /d "%~dp0"

echo ===================================================================
echo   ResQCore Disaster Management Platform - Multi-Client Hub
echo ===================================================================
echo   [1/4] Starting Unified Backend Hub (Port 5000)...
start "ResQCore Backend Hub (Port 5000)" cmd /c "cd /d "%~dp0backend" && node server.js"

echo   [2/4] Waiting for Backend Hub to initialize ports 5000, 8081, 8082...
timeout /t 3 /nobreak >nul

echo   [3/4] Starting Command Center Web App (Port 5173)...
start "ResQCore Command Center (Port 5173)" cmd /c "cd /d "%~dp0CC" && npm.cmd run dev -- --host 0.0.0.0"

echo   [4/4] Starting Independent Web Runners for Citizen & Tactical...
start "ResQCore Citizen App (Port 8081)" cmd /c "cd /d "%~dp0RescueCoreF" && node serve.js"
start "ResQCore Tactical Ops (Port 8082)" cmd /c "cd /d "%~dp0RescueApp" && node serve.js"

echo ===================================================================
echo   Opening All 4 Applications in Your Browser...
echo ===================================================================
timeout /t 3 /nobreak >nul

start http://localhost:5173
start http://localhost:8081
start http://localhost:8082
start http://localhost:5000

echo.
echo All 4 applications are running and connected together in real-time!
echo.
echo - [1] Command Center Web App:   http://localhost:5173
echo - [2] Citizen Emergency App:     http://localhost:8081
echo - [3] Tactical Field Ops App:    http://localhost:8082
echo - [4] Unified Backend & Hub:     http://localhost:5000
echo.
echo Real-time synchronization active across all 4 apps via ws://localhost:5000/ws
echo.
pause
