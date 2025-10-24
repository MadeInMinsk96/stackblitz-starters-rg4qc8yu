@echo off
rem Metal Production System - Setup Script for Windows
rem Автоматическая настройка проекта

echo 🚀 Настройка Metal Production System...
echo ======================================

rem Проверка наличия Node.js
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Node.js не найден. Установите Node.js 18+ с https://nodejs.org
    pause
    exit /b 1
)

echo ✅ Node.js найден

rem Установка pnpm если не установлен
pnpm --version >nul 2>&1
if %errorlevel% neq 0 (
    echo 📦 Установка pnpm...
    npm install -g pnpm
)

echo ✅ pnpm готов

rem Переход в директорию проекта
cd metal-production-system

rem Установка зависимостей
echo 📦 Установка зависимостей...
pnpm install

rem Создание .env.local если не существует
if not exist ".env.local" (
    echo 🔧 Создание файла конфигурации .env.local...
    copy .env.example .env.local
    echo.
    echo ⚠️  ВАЖНО: Настройте Supabase в файле .env.local
    echo    Откройте .env.local и добавьте ваши ключи Supabase
    echo.
)

rem Инициализация Git если не инициализирован
if not exist ".git" (
    echo 🔄 Инициализация Git репозитория...
    git init
    git add .
    git commit -m "Initial commit: Metal Production Management System"
    
    echo.
    echo 📋 Для загрузки на GitHub выполните:
    echo    git remote add origin https://github.com/YOUR_USERNAME/metal-production-system.git
    echo    git branch -M main
    echo    git push -u origin main
    echo.
)

rem Проверка линтинга
echo 🔍 Проверка кода...
pnpm lint

echo.
echo 🎉 Проект готов!
echo ==================
echo.
echo Команды для запуска:
echo   pnpm dev      - запуск в режиме разработки
echo   pnpm build    - сборка для продакшена
echo   pnpm preview  - предварительный просмотр сборки
echo.
set /p response="⚡ Запустить проект сейчас? (y/n): "
if /i "%response%"=="y" (
    echo 🚀 Запуск сервера разработки...
    pnpm dev
)

pause