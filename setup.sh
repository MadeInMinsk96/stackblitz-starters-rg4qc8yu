#!/bin/bash

# Metal Production System - Setup Script
# Автоматическая настройка проекта

set -e

echo "🚀 Настройка Metal Production System..."
echo "======================================"

# Проверка наличия Node.js
if ! command -v node &> /dev/null; then
    echo "❌ Node.js не найден. Установите Node.js 18+ с https://nodejs.org"
    exit 1
fi

# Проверка версии Node.js
NODE_VERSION=$(node -v | cut -d 'v' -f 2 | cut -d '.' -f 1)
if [ "$NODE_VERSION" -lt 18 ]; then
    echo "❌ Требуется Node.js версии 18 или выше. Текущая версия: $(node -v)"
    exit 1
fi

echo "✅ Node.js $(node -v) найден"

# Установка pnpm если не установлен
if ! command -v pnpm &> /dev/null; then
    echo "📦 Установка pnpm..."
    npm install -g pnpm
fi

echo "✅ pnpm $(pnpm -v) готов"

# Переход в директорию проекта
cd metal-production-system

# Установка зависимостей
echo "📦 Установка зависимостей..."
pnpm install

# Создание .env.local если не существует
if [ ! -f ".env.local" ]; then
    echo "🔧 Создание файла конфигурации .env.local..."
    cp .env.example .env.local
    echo ""
    echo "⚠️  ВАЖНО: Настройте Supabase в файле .env.local"
    echo "   Откройте .env.local и добавьте ваши ключи Supabase"
    echo ""
fi

# Инициализация Git если не инициализирован
if [ ! -d ".git" ]; then
    echo "🔄 Инициализация Git репозитория..."
    git init
    git add .
    git commit -m "Initial commit: Metal Production Management System"
    
    echo ""
    echo "📋 Для загрузки на GitHub выполните:"
    echo "   git remote add origin https://github.com/YOUR_USERNAME/metal-production-system.git"
    echo "   git branch -M main"
    echo "   git push -u origin main"
    echo ""
fi

# Проверка линтинга
echo "🔍 Проверка кода..."
pnpm lint

echo ""
echo "🎉 Проект готов!"
echo "=================="
echo ""
echo "Команды для запуска:"
echo "  pnpm dev      - запуск в режиме разработки"
echo "  pnpm build    - сборка для продакшена"
echo "  pnpm preview  - предварительный просмотр сборки"
echo ""
echo "⚡ Запустить проект сейчас? (y/n)"
read -r response
if [[ "$response" =~ ^[Yy]$ ]]; then
    echo "🚀 Запуск сервера разработки..."
    pnpm dev
fi