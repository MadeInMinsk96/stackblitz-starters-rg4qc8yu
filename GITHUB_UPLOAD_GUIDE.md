# Инструкция по загрузке на GitHub

## Шаг 1: Создание репозитория на GitHub

1. Перейдите на [GitHub](https://github.com)
2. Нажмите кнопку "New repository" (зеленая кнопка)
3. Заполните данные:
   - **Repository name**: `metal-production-system`
   - **Description**: "Modern metal production management system built with React, TypeScript and Vite"
   - Выберите "Public" или "Private" в зависимости от ваших потребностей
   - **НЕ** ставьте галочки на "Add a README file", "Add .gitignore", "Choose a license" (они уже созданы)
4. Нажмите "Create repository"

## Шаг 2: Инициализация Git в проекте

Откройте терминал в папке `metal-production-system` и выполните:

```bash
# Инициализация git репозитория
git init

# Добавление всех файлов
git add .

# Первый коммит
git commit -m "Initial commit: Metal Production Management System"

# Добавление remote origin (замените YOUR_USERNAME на ваш GitHub username)
git remote add origin https://github.com/YOUR_USERNAME/metal-production-system.git

# Создание основной ветки
git branch -M main

# Загрузка на GitHub
git push -u origin main
```

## Шаг 3: Настройка секретов для Supabase (опционально)

Если вы планируете использовать GitHub Actions или Vercel для деплоя:

1. В репозитории на GitHub перейдите в Settings → Secrets and variables → Actions
2. Добавьте секреты:
   - `VITE_SUPABASE_URL`
   - `VITE_SUPABASE_ANON_KEY`

## Шаг 4: Обновление URL в package.json

Откройте `package.json` и обновите поле repository:

```json
"repository": {
  "type": "git",
  "url": "https://github.com/YOUR_USERNAME/metal-production-system.git"
}
```

Затем сделайте commit и push:

```bash
git add package.json
git commit -m "Update repository URL in package.json"
git push
```

## Готово! 🎉

Ваш проект теперь доступен на GitHub и готов для:

- Совместной разработки
- Создания Issues и Pull Requests
- Деплоя на платформы типа Vercel, Netlify
- Настройки CI/CD

### Полезные команды Git:

```bash
# Клонирование репозитория
git clone https://github.com/YOUR_USERNAME/metal-production-system.git

# Создание новой ветки
git checkout -b feature/new-feature

# Просмотр статуса
git status

# Добавление изменений
git add .

# Коммит
git commit -m "Describe your changes"

# Push изменений
git push origin branch-name
```