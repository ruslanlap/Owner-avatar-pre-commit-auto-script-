#!/bin/bash

# Кольорові коди
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Функція створення файлу .gitleaks.toml
create_gitleaks_config() {
    echo '[[rules]]
regex = "API[_-]?KEY"
tags = ["api-key", "token" ]' > .gitleaks.toml
}

# Визначення операційної системи
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="darwin"
else
    echo -e "${RED}Операційна система не підтримується.${NC}"
    exit 1
fi

echo -e "${BLUE}Операційна система: ${BOLD}$OS${NC}"

# Визначення архітектури
ARCH=$(uname -m)
if [[ "$ARCH" == "x86_64" ]]; then
    ARCH="amd64"
elif [[ "$ARCH" == "aarch64" ]]; then
    ARCH="arm64"
else
    echo -e "${RED}Архітектура не підтримується.${NC}"
    exit 1
fi

echo -e "${BLUE}Архітектура: ${BOLD}$ARCH${NC}"

# Завантаження та встановлення gitleaks
echo -e "${GREEN}Завантаження та встановлення gitleaks...${NC}"

RELEASE_URL=""
if [[ "$OS" == "darwin" ]]; then
    RELEASE_URL="https://github.com/gitleaks/gitleaks/releases/download/v8.16.4/gitleaks_8.16.4_darwin_x64.tar.gz"
elif [[ "$OS" == "linux" ]]; then
    if [[ "$ARCH" == "amd64" ]]; then
        RELEASE_URL="https://github.com/gitleaks/gitleaks/releases/download/v8.16.4/gitleaks_8.16.4_linux_x64.tar.gz"
    elif [[ "$ARCH" == "arm64" ]]; then
        RELEASE_URL="https://github.com/gitleaks/gitleaks/releases/download/v8.16.4/gitleaks_8.16.4_linux_arm64.tar.gz"
    fi
fi

if [[ -z "$RELEASE_URL" ]]; then
    echo -e "${RED}Не вдалося знайти відповідну версію gitleaks для даної операційної системи та архітектури.${NC}"
    exit 1
fi

# Завантаження та розархівування gitleaks
curl -sSL "$RELEASE_URL" -o gitleaks.tar.gz
tar -xf gitleaks.tar.gz
chmod +x gitleaks

# Копіювання gitleaks до /usr/local/bin/
sudo cp gitleaks /usr/local/bin

echo -e "${GREEN}gitleaks встановлено.${NC}"

# Створення файлу .gitleaks.toml
echo -e "${GREEN}Створення файлу .gitleaks.toml...${NC}"
create_gitleaks_config

# Видалення тимчасових файлів
rm gitleaks.tar.gz gitleaks
git restore README.md

GITLEAKS_VERSION=$(gitleaks version)
echo -e "Версія gitleaks: ${GREEN}${BOLD}${GITLEAKS_VERSION}!${NC}"

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