#!/bin/bash

# Metal Production System - GitHub Deploy Script
# Автоматический деплой на GitHub

set -e

echo "🚀 Автоматический деплой на GitHub"
echo "===================================="

# Проверка наличия git
if ! command -v git &> /dev/null; then
    echo "❌ Git не найден. Установите Git с https://git-scm.com"
    exit 1
fi

# Проверка аутентификации GitHub
if ! git config user.name &> /dev/null || ! git config user.email &> /dev/null; then
    echo "🔧 Настройка Git..."
    read -p "Введите ваше имя для Git: " git_name
    read -p "Введите ваш email для Git: " git_email
    
    git config --global user.name "$git_name"
    git config --global user.email "$git_email"
fi

echo "✅ Git настроен для $(git config user.name) <$(git config user.email)>"

# Переход в директорию проекта
cd metal-production-system

# Запрос информации о репозитории
echo ""
read -p "📝 Введите ваш GitHub username: " github_username
read -p "📝 Введите название репозитория (metal-production-system): " repo_name

# Значение по умолчанию
repo_name=${repo_name:-metal-production-system}

# Обновление package.json с правильным URL
sed -i "s/yourusername/$github_username/g" package.json

# Формирование URL репозитория
repo_url="https://github.com/$github_username/$repo_name.git"

echo ""
echo "📋 Будет создан репозиторий: $repo_url"
echo ""

# Инициализация или обновление Git
if [ ! -d ".git" ]; then
    echo "🔄 Инициализация Git репозитория..."
    git init
else
    echo "🔄 Обновление Git репозитория..."
fi

# Добавление файлов
echo "📦 Добавление файлов..."
git add .

# Проверка изменений
if git diff --staged --quiet; then
    echo "ℹ️  Нет изменений для коммита"
else
    # Коммит
    echo "💾 Создание коммита..."
    git commit -m "Deploy: Metal Production Management System - $(date '+%Y-%m-%d %H:%M:%S')"
fi

# Настройка remote
if git remote get-url origin &> /dev/null; then
    echo "🔄 Обновление remote origin..."
    git remote set-url origin "$repo_url"
else
    echo "🔗 Добавление remote origin..."
    git remote add origin "$repo_url"
fi

# Установка главной ветки
git branch -M main

echo ""
echo "🚀 Загрузка на GitHub..."
echo ""
echo "⚠️  Убедитесь что:"
echo "   1. Репозиторий $repo_name создан на GitHub"
echo "   2. У вас есть права на запись в репозиторий"
echo ""
read -p "Продолжить загрузку? (y/n): " confirm

if [[ "$confirm" =~ ^[Yy]$ ]]; then
    echo "📤 Загрузка..."
    git push -u origin main
    
    echo ""
    echo "🎉 Успешно загружено!"
    echo "========================"
    echo ""
    echo "🔗 Ваш репозиторий: https://github.com/$github_username/$repo_name"
    echo "📖 README: https://github.com/$github_username/$repo_name#readme"
    echo ""
    echo "📋 Следующие шаги:"
    echo "   1. Настройте Supabase ключи в Settings → Secrets"
    echo "   2. Настройте деплой на Vercel/Netlify (опционально)"
    echo "   3. Пригласите соавторов (опционально)"
    echo ""
else
    echo "❌ Загрузка отменена"
fi