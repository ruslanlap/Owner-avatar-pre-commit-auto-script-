#!/bin/bash

# Визначте URL репозиторію, де знаходиться скрипт pre-commit
REPO_URL="https://raw.githubusercontent.com/<OWNER>/<REPO>/main/pre-commit"

# Визначте шлях до директорії hooks у вашому репозиторії Git
HOOKS_DIR=".git/hooks"

# Переконайтеся, що директорія hooks існує
mkdir -p "$HOOKS_DIR"

# Встановлення pre-commit hook
echo "Завантаження pre-commit hook..."
curl -sSfL "$REPO_URL" -o "$HOOKS_DIR/pre-commit"
chmod +x "$HOOKS_DIR/pre-commit"

echo "Pre-commit hook встановлено успішно!"
