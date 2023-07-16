#!/bin/bash

# This function disables Gitleaks.
function disable_gitleaks() {
  echo "Disable Gitleaks"
  git config core.hooksPath no-hooks
}

# Call the function to disable Gitleaks

# This function enable Gitleaks.
function enable_gitleaks () {
  echo "Enable Gitleaks"
  git config --unset core.hooksPath
}
# Call the function to enable Gitleaks
