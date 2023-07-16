#!/bin/bash

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
