#!/bin/bash

# Ця функція активує Gitleaks.
function gitleaks_enable() {
  echo "Enable Gitleaks"
  git config --global gitleaks.enable 1
}

# Ця функція вимикає Gitleaks.
function gitleaks_disable() {
  echo "Disable Gitleaks"
  git config --global gitleaks.enable 0
}