#!/usr/bin/env bash

# Manage multiple-versions python by pyenv
# Is pyenv works?
if [[ ! $(type -P pyenv) ]]; then
      # Install pyenv
      formulas=(pyenv)
      install_brew_formulas
else
  reportSuccess "pyenv"
fi
