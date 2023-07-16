#!/bin/bash

# Кольорові коди
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

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

config_file=".git/config"

# Set gitleaks.enabled to true
sed -i 's/gitleaks.enabled = false/gitleaks.enabled = true/' "$config_file"

# Enable gitleaks using git config
git config gitleaks.enable true

# Disable pre-commit hook
# Ця функція активує Gitleaks.
function gitleaks_enable() {
  echo "Enable Gitleaks"
  git config --global gitleaks.enable true
}

# Ця функція вимикає Gitleaks.
function gitleaks_disable() {
  echo "Disable Gitleaks"
  git config --global gitleaks.enable false
}
