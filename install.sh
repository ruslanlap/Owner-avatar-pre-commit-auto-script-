#!/bin/bash

# Color codes and emojis
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

# Determine the operating system
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="darwin"
else
    echo -e "${RED}Unsupported operating system.${NC}"
    exit 1
fi

echo -e "${BLUE}Operating System: ${BOLD}$OS${NC}"

# Determine the architecture
ARCH=$(uname -m)
if [[ "$ARCH" == "x86_64" ]]; then
    ARCH="amd64"
elif [[ "$ARCH" == "aarch64" ]]; then
    ARCH="arm64"
else
    echo -e "${RED}Unsupported architecture.${NC}"
    exit 1
fi

echo -e "${BLUE}Architecture: ${BOLD}$ARCH${NC}"

# Download and install gitleaks
echo -e "${GREEN}Downloading and installing gitleaks...${NC}"

RELEASE_VERSION="v8.17.0" # Change the version number here
RELEASE_URL=""
if [[ "$OS" == "darwin" ]]; then
    RELEASE_URL="https://github.com/gitleaks/gitleaks/releases/download/$RELEASE_VERSION/gitleaks_8.16.4_darwin_x64.tar.gz"
elif [[ "$OS" == "linux" ]]; then
    if [[ "$ARCH" == "amd64" ]]; then
        RELEASE_URL="https://github.com/gitleaks/gitleaks/releases/download/$RELEASE_VERSION/gitleaks-linux-amd64"
    elif [[ "$ARCH" == "arm64" ]]; then
        RELEASE_URL="https://github.com/gitleaks/gitleaks/releases/download/$RELEASE_VERSION/gitleaks_8.16.4_linux_arm64.tar.gz"
    fi
fi

if [[ -z "$RELEASE_URL" ]]; then
    echo -e "${RED}Unable to find a compatible version of gitleaks for this operating system and architecture.${NC}"
    exit 1
fi

# Download and extract gitleaks
curl -sSL "$RELEASE_URL" -o gitleaks.tar.gz
tar -xf gitleaks.tar.gz
chmod +x gitleaks

# Copy gitleaks to /usr/local/bin/
# sudo cp gitleaks /usr/local/bin

echo -e "${GREEN}Gitleaks installed.${NC}"

# Create .gitleaks.toml file
echo -e "${GREEN}Creating .gitleaks.toml file...${NC}"
create_gitleaks_config

# Remove temporary files
rm gitleaks.tar.gz gitleaks
git restore README.md

GITLEAKS_VERSION=$(gitleaks version)
echo -e "Gitleaks version: ${GREEN}${BOLD}${GITLEAKS_VERSION}!${NC}"

# Define the URL of the repository where the pre-commit script is located
REPO_URL="https://raw.githubusercontent.com/matvrus/pre-commit-auto-script/main/pre-commit.sh"

# Define the path to the hooks directory in your Git repository
HOOKS_DIR=".git/hooks"

# Ensure that the hooks directory exists
mkdir -p "$HOOKS_DIR"

# Install the pre-commit hook
echo -e "${BLUE}Downloading pre-commit hook...${NC}"
curl -sSfL "$REPO_URL" -o "$HOOKS_DIR/pre-commit"
chmod +x "$HOOKS_DIR/pre-commit"

if [ -f "$HOOKS_DIR/pre-commit" ]; then
    echo -e "${GREEN}${CHECK_MARK} Pre-commit hook script installed successfully!${NC}"
else
    echo -e "${RED}${CROSS_MARK} An error occurred while installing the pre-commit hook script.${NC}"
fi

download-onoffscript() {
    # Download the gitleaks.sh file from the GitHub repository
    curl -sSfL "https://raw.githubusercontent.com/matvrus/pre-commit-auto-script/main/on-off-gitleaks.sh" -o on-off-gitleaks.sh
    chmod +x on-off-gitleaks.sh
}

download-onoffscript
rm LICENSE
