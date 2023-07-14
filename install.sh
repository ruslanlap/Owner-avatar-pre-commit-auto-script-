#!/bin/bash

# Кольорові коди та емоджі
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color
CHECK_MARK="\xE2\x9C\x94"
CROSS_MARK="\xE2\x9D\x8C"

# Перевірка, чи є поточна директорія репозиторієм Git
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo -e "${RED}Поточна директорія не є репозиторієм Git.${NC}"
    exit 1
fi

# Визначте URL репозиторію, де знаходиться скрипт pre-commit
REPO_URL="https://raw.githubusercontent.com/matvrus/pre-commit-auto-script/main/pre-commit.sh"

# Визначте шлях до директорії hooks у вашому репозиторії Git
HOOKS_DIR=".git/hooks"

# Переконайтеся, що директорія hooks існує
mkdir -p "$HOOKS_DIR"

# Встановлення pre-commit hook
echo -e "${BLUE}Завантаження pre-commit hook...${NC}"
curl -sSfL "$REPO_URL" -o "$HOOKS_DIR/pre-commit"
chmod +x "$HOOKS_DIR/pre-commit"

if [ -f "$HOOKS_DIR/pre-commit" ]; then
    echo -e "${GREEN}${CHECK_MARK} Pre-commit hook script встановлено успішно!${NC}"
else
    echo -e "${RED}${CROSS_MARK} Виникла помилка під час встановлення pre-commit hook script.${NC}"
fi
