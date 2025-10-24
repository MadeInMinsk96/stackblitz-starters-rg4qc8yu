#!/bin/bash

# Metal Production System - ONE CLICK SETUP
# Полная автоматическая установка и деплой одной командой

set -e

echo "🎯 АВТОМАТИЧЕСКАЯ УСТАНОВКА ВСЕГО"
echo "================================="
echo ""
echo "Этот скрипт выполнит:"
echo "✅ Установка зависимостей"
echo "✅ Настройка конфигурации"  
echo "✅ Инициализация Git"
echo "✅ Загрузка на GitHub"
echo "✅ Запуск проекта"
echo ""

read -p "🚀 Начать автоматическую установку? (y/n): " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "❌ Установка отменена"
    exit 0
fi

echo ""
echo "📋 Сбор информации..."

# Сбор всей необходимой информации заранее
read -p "👤 Ваш GitHub username: " github_username
read -p "📁 Название репозитория [metal-production-system]: " repo_name
repo_name=${repo_name:-metal-production-system}

read -p "🔧 Ваше имя для Git: " git_name
read -p "📧 Ваш email для Git: " git_email

echo ""
read -p "🔑 Введите Supabase URL (или нажмите Enter для настройки позже): " supabase_url
read -p "🔑 Введите Supabase Anon Key (или нажмите Enter для настройки позже): " supabase_key

echo ""
echo "🎬 НАЧИНАЕМ АВТОМАТИЧЕСКУЮ УСТАНОВКУ!"
echo "====================================="

# 1. Проверка системы
echo "1️⃣ Проверка системы..."
if ! command -v node &> /dev/null; then
    echo "❌ Node.js не найден. Установите с https://nodejs.org"
    exit 1
fi

if ! command -v git &> /dev/null; then
    echo "❌ Git не найден. Установите с https://git-scm.com"
    exit 1
fi

# 2. Установка pnpm
echo "2️⃣ Установка pnpm..."
if ! command -v pnpm &> /dev/null; then
    npm install -g pnpm
fi

# 3. Настройка Git
echo "3️⃣ Настройка Git..."
git config --global user.name "$git_name"
git config --global user.email "$git_email"

# 4. Установка проекта
echo "4️⃣ Установка зависимостей..."
cd metal-production-system
pnpm install

# 5. Настройка конфигурации
echo "5️⃣ Настройка конфигурации..."
cp .env.example .env.local

if [ ! -z "$supabase_url" ] && [ ! -z "$supabase_key" ]; then
    sed -i "s|your_supabase_project_url|$supabase_url|g" .env.local
    sed -i "s|your_supabase_anon_key|$supabase_key|g" .env.local
    echo "✅ Supabase настроен"
else
    echo "⚠️  Supabase нужно будет настроить вручную в .env.local"
fi

# 6. Обновление package.json
echo "6️⃣ Обновление конфигурации..."
sed -i "s/yourusername/$github_username/g" package.json

# 7. Проверка кода
echo "7️⃣ Проверка кода..."
pnpm lint

# 8. Git операции
echo "8️⃣ Инициализация Git..."
git init
git add .
git commit -m "🚀 Initial commit: Metal Production Management System"

repo_url="https://github.com/$github_username/$repo_name.git"
git remote add origin "$repo_url"
git branch -M main

# 9. Создание GitHub репозитория (автоматически)
echo "9️⃣ Создание GitHub репозитория..."
echo ""
echo "📝 СЕЙЧАС ОТКРОЕТСЯ БРАУЗЕР:"
echo "   1. Создайте репозиторий: $repo_name"
echo "   2. НЕ добавляйте README, .gitignore или лицензию"
echo "   3. Нажмите 'Create repository'"
echo ""

# Открытие GitHub в браузере
if command -v open &> /dev/null; then
    open "https://github.com/new"
elif command -v xdg-open &> /dev/null; then
    xdg-open "https://github.com/new"
elif command -v start &> /dev/null; then
    start "https://github.com/new"
fi

read -p "✅ Репозиторий создан? Нажмите Enter для продолжения..."

# 10. Загрузка на GitHub
echo "🔟 Загрузка на GitHub..."
git push -u origin main

echo ""
echo "🎉 ПОЛНАЯ УСТАНОВКА ЗАВЕРШЕНА!"
echo "============================="
echo ""
echo "🔗 Ваш проект: https://github.com/$github_username/$repo_name"
echo ""
echo "📋 Что дальше:"
echo "   • Проект запустится автоматически через 3 секунды"
echo "   • Откройте http://localhost:5173 в браузере"
if [ -z "$supabase_url" ] || [ -z "$supabase_key" ]; then
    echo "   • Настройте Supabase в .env.local"
fi
echo ""

# 11. Автоматический запуск
echo "🚀 Автоматический запуск через:"
for i in 3 2 1; do
    echo "   $i..."
    sleep 1
done

echo ""
echo "🎯 ЗАПУСК ПРОЕКТА!"
pnpm dev