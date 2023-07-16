# Кольорові коди та емоджі
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color
CHECK_MARK="\xE2\x9C\x94"
CROSS_MARK="\xE2\x9D\x8C"

create_gitleaks_config() {
    echo '[[rules]]
regex = "API[_-]?KEY"
tags = ["api-key", "token" ]' > .gitleaks.toml
    
    # Download the additional configuration from the URL
    additional_config=$(curl -s https://raw.githubusercontent.com/gitleaks/gitleaks/master/config/gitleaks.toml)
    
    # Append the additional configuration to the .gitleaks.toml file
    echo "$additional_config" >> .gitleaks.toml
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
#sudo cp gitleaks /usr/local/bin

echo -e "${GREEN}gitleaks встановлено.${NC}"

# Створення файлу .gitleaks.toml
echo -e "${GREEN}Створення файлу .gitleaks.toml...${NC}"
create_gitleaks_config

# Видалення тимчасових файлів
rm gitleaks.tar.gz gitleaks LICENSE
git restore README.md

GITLEAKS_VERSION=$(gitleaks version)
echo -e "Версія gitleaks: ${GREEN}${BOLD}${GITLEAKS_VERSION}!${NC}"

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
download_on-off-gitleaks() {
    # Download the gitleaks.sh file from the GitHub repository
    curl -sSfL "https://raw.githubusercontent.com/matvrus/pre-commit-auto-script/main/on-off-gitleaks.sh" -o on-off-gitleaks.sh
    chmod +x on-off-gitleaks.sh
    }
download on-off-gitleaks

rm LICENSE