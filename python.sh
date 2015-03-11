#!/usr/bin/env bash

# Manage multiple-versions python envoriments by pyenv

# Clean up brewed pyenv
clean_up_brewed_packages pyenv

# Looking for pyenv local repo root
pyenv=$(type -P pyenv)

[[ $pyenv ]] && {
  # strip trailing bin
  local_repo=${pyenv%%/bin/pyenv}
  if [[ $local_repo = $pyenv ]]; then
    # trailing bin not stripped
    false
  fi
} || local_repo=$HOME/.pyenv

remote_repo=https://github.com/yyuu/pyenv.git

update_git_repo $local_repo $remote_repo

# Install pyenv plugins
plugins=("pyenv-virtualenv"
         "pyenv-doctor"
         "pyenv-update"
         "pyenv-which-ext"
         "pyenv-pip-migrate")

for plugin in ${plugins[@]}; do
  update_git_repo "$local_repo/plugins/$plugin" \
  "https://github.com/yyuu/$plugin.git"
done
