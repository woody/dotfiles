#!/usr/bin/env bash

# Manage multiple-versions python envoriments by pyenv

# Clean up brewed pyenv
clean_up_brewed_packages pyenv

# Looking for pyenv local repo root
if [ -z "$PYENV_ROOT" ]; then
  export PYENV_ROOT="$HOME/.plugins/pyenv"
fi

update_github_repo "$PYENV_ROOT" "yyuu/pyenv"

# Install pyenv plugins
plugins=("yyuu/pyenv-virtualenv"
         "yyuu/pyenv-doctor"
         "yyuu/pyenv-update"
         "yyuu/pyenv-which-ext"
         "yyuu/pyenv-pip-migrate")

for plugin in ${plugins[@]}; do
  update_github_repo "$PYENV_ROOT/plugins/${plugin##*/}" $plugin
done

# Update path
path=$(path_remove "$PYENV_ROOT/bin")
export PATH="$PYENV_ROOT/bin":$path
