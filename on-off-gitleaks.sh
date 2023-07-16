#!/bin/bash

# Кольорові коди
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# This function disables Gitleaks.
function disable() {
  echo -e "${RED}Disable Gitleaks...${NC}"
  git config core.hooksPath no-hooks
}

# Call the function to disable Gitleaks

# This function enable Gitleaks.
function enable() {
  echo -e "${GREEN}Enable Gitleaks...${NC}"
  git config --unset core.hooksPath
}
# Call the function to enable Gitleaks
