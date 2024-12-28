@echo off

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Solicitando permissoes de administrador...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: UserInput
set /p minutes=Digite o numero de minutos para desligar o sistema: 

echo O PC sera desligado em %minutes% minutos ...
:: ConversionSecondsToMinutes
set /a seconds=%minutes%*60

:: GetCurrentTime
for /f "tokens=1-3 delims=:" %%a in ("%time%") do (
    set current_hour=%%a
    set current_minute=%%b
)

:: CleanupZeros
set /a current_hour=1%current_hour%-100
set /a current_minute=1%current_minute%-100

:: GetShutdownTime
set /a shutdown_hour=(%current_hour% + (%minutes% + %current_minute%) / 60) %% 24
set /a shutdown_minute=(%current_minute% + %minutes%) %% 60

:: CleanupZerosShutdownTime
if %shutdown_hour% LSS 10 set shutdown_hour=0%shutdown_hour%
if %shutdown_minute% LSS 10 set shutdown_minute=0%shutdown_minute%

echo Previsao de desligamento: %shutdown_hour%:%shutdown_minute%

:: SetShutdown
shutdown -s -t %seconds%


echo Tudo certo!
:: GetAssertment
echo O sistema sera desligado em %minutes% minutos, aproximadamente as %shutdown_hour%:%shutdown_minute%.
pause