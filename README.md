
# pre-commit hook script with automatic installation of [gitleaks](https://github.com/gitleaks/gitleaks)

  

# Pre-commit Auto Script

  

![GitHub](https://img.shields.io/github/license/matvrus/pre-commit-auto-script) ![GitHub last commit](https://img.shields.io/github/last-commit/matvrus/pre-commit-auto-script) ![GitHub issues](https://img.shields.io/github/issues/matvrus/pre-commit-auto-script)

  

This repository contains the `pre-commit-auto-script`, a script that helps automate the installation and configuration of `pre-commit` hooks in your Git repository. It utilizes [gitleaks](https://github.com/zricethezav/gitleaks) to enhance the security of your codebase.

  

``````

[![Typing SVG](https://readme-typing-svg.herokuapp.com?color=%2336BCF7&lines=pre-+commit-+auto-+script)](https://git.io/typing-svg)

``````

## Requirements

  

Before using this script, make sure you have the following dependencies installed:

  

- Git

- Curl

  

## Installation
just copy and run the command

```
curl -sSfL https://raw.githubusercontent.com/matvrus/pre-commit-auto-script/main/install.sh | bash

```

## Usage

After running the `curl -sSfL https://raw.githubusercontent.com/matvrus/pre-commit-auto-script/main/install.sh | bash`, it will automatically install and configure `pre-commit` hooks for your Git repository. It also integrates `gitleaks` to scan for sensitive information in your codebase and prevent leaks.

You can review and customize the list of available hooks in the `.pre-commit-config.yaml` file, which will be created in the root directory of your project. For example, you can add more arguments to the `.gitleaks.toml` file.
## DEMO
How does the script work?
An image: ![Alt](data/demo.gif)
An image: ![Alt](data/Example1.png)
An image: ![Alt](data/Example2.png)
