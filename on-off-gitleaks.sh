#!/bin/bash

# This function disables Gitleaks.
function disable() {
  echo "Disable Gitleaks"
  git config core.hooksPath no-hooks
}

# Call the function to disable Gitleaks
disable

# This function enable Gitleaks.
function enable() {
  echo "Enable Gitleaks"
  git config --unset core.hooksPath
}
# Call the function to enable Gitleaks
enable