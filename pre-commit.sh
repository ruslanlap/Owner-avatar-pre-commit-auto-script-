#!/bin/bash

# Color codes for terminal output
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Check if gitleaks is enabled in Git config
ENABLE=$(git config --bool hooks.gitleaks-enable)

# Running gitleaks to detect secrets in the repository
echo -e "${GREEN}Running gitleaks...${NC}"
gitleaksOutput=$(gitleaks detect --redact --verbose --report-format json --report-path gitleaks-report.json --config .gitleaks.toml)
gitleaksExitCode=$?

# Check if gitleaks found any secrets in the repository
if [[ $gitleaksExitCode -eq 1 ]]; then
    echo -e "${RED}Found the following secrets:${NC}"
    echo "$gitleaksOutput"
    echo -e "${RED}Committing with existing secrets is not allowed.${NC}"
    exit 1
else
    echo -e "${GREEN}Secrets check passed successfully.${NC}"
fi

# Make the 'on-off-gitleaks.sh' script executable
chmod +x on-off-gitleaks.sh
