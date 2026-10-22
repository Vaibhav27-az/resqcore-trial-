@echo off
title ResQCore Command Center Web Application - Port 5173
cd /d "%~dp0CC"

echo ===================================================================
echo   ResQCore Command Center Web Application (React + Vite)
echo   Local Server: http://localhost:5173
echo   Backend Hub:  http://localhost:5000
echo ===================================================================
echo.
echo [1] Opening Command Center in default browser (http://localhost:5173)...
timeout /t 2 /nobreak >nul
start http://localhost:5173

echo [2] Starting Vite Dev Server on port 5173...
npm.cmd run dev -- --host 0.0.0.0
pause
