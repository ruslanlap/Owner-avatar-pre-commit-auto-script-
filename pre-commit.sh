#!/bin/bash

# Кольорові коди
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Змінні конфігурації
GIT_LEAKS_ENABLED_CONFIG="gitleaks.enabled"

# Запуск gitleaks
echo -e "${GREEN}Запуск gitleaks...${NC}"
gitleaksOutput=$(gitleaks detect --redact --verbose --report-format json --report-path gitleaks-report.json --config .gitleaks.toml)
gitleaksExitCode=$?

if [[ $gitleaksExitCode -eq 1 ]]; then
    echo -e "${RED}Знайдено наступні секрети:${NC}"
    echo "$gitleaksOutput"
    echo -e "${RED}Заборонено затверджувати коміти з наявними секретами.${NC}"
    exit 1
else
    echo -e "${GREEN}Перевірка секретів пройшла успішно.${NC}"
fi

# Вимкнути pre-commit hook
echo -e "${BLUE}Вимкнення pre-commit hook...${NC}"
git config $GIT_LEAKS_ENABLED_CONFIG false
echo -e "${BLUE}Pre-commit hook вимкнено.${NC}"

# Включити pre-commit hook
echo -e "${BLUE}Включення pre-commit hook...${NC}"
git config $GIT_LEAKS_ENABLED_CONFIG true
echo -e "${BLUE}Pre-commit hook включено.${NC}"
