@echo off
chcp 65001
cls

setlocal EnableDelayedExpansion

:: Проверка прав администратора
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo Требуются права администратора. Перезапуск...
    timeout /nobreak /t 1 >nul
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:MENU
cls
echo.
echo ==================================
echo    Mobile Hotspot Limit Manager
echo ==================================
echo.
echo 1) Установить лимит подключений 99
echo 2) Сбросить лимит до значения по умолчанию (8)
echo.
set /p choice=Выберите опцию (1 или 2): 

if "%choice%"=="1" goto SET_LIMIT
if "%choice%"=="2" goto RESET_LIMIT
echo.
echo Неправильное значение, Причина: вы не достаточно развитый чтобы выбрать 1 или 2.
timeout /t 2 >nul
goto MENU

:SET_LIMIT
echo.
echo Установка лимита подключений на 99...
reg add "HKLM\SYSTEM\CurrentControlSet\Services\icssvc\Settings" /v WifiMaxPeers /t REG_DWORD /d 99 /f >nul
if errorlevel 1 (
    echo.
    echo [X] Ошибка при изменении реестра.
    timeout /t 2 >nul
    goto MENU
)
echo Перезапуск службы "Internet Connection Sharing"...
powershell -Command "Restart-Service icssvc"
echo.
echo [+] Лимит успешно установлен на 99
echo.
echo [WARN] ПОЖАЛУЙСТА ПЕРЕЗАГРУЗИТЕ КОМПЬЮТЕР.
pause
goto MENU

:RESET_LIMIT
echo.
echo Сброс лимита подключений до значения по умолчанию (8)...
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\icssvc\Settings" /v WifiMaxPeers /f >nul
if errorlevel 1 (
    echo.
    echo [!] Ключ не найден или уже удалён.
) else (
    echo [✓] Ключ успешно удалён.
)
echo Перезапуск службы "Internet Connection Sharing"...
powershell -Command "Restart-Service icssvc"
echo.
echo [+] Лимит сброшен до стандартного значения.
pause
goto MENU
