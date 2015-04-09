#!/usr/bin/env bash

# Manage multiple-versions ruby envoriments by rbenv

if [[ ! $BREW_INCLUDED ]]; then source brew.sh; fi
if [[ ! $GIT_INCLUDED ]]; then source git.sh; fi
if [[ ! $PATH_INCLUDED ]]; then source path.sh; fi


# Manually install rbenv instead of brewed
remove_brewed_packages rbenv

# Looking for rbenv local repo root
if [ -z "$RBENV_ROOT" ]; then
  export RBENV_ROOT="$HOME/.dotfiles/.plugins/rbenv"
fi

# Remove non-builtin rbenv from PATH
RBENV_PATH=$(type -P rbenv)

if [[ $RBENV_PATH ]]; then
  RBENV_BIN=$(dirname "$RBENV_PATH")
  RBENV_SHIMS="$(dirname "$RBEVN_BIN")/shims"
fi

if [[ $RBENV_BIN != $RBENV_ROOT/bin ]]; then
  path_remove "$RBENV_BIN"
fi

if [[ $RBEVN_SHIMS != $RBENV_ROOT/shims ]]; then
  path_remove "$RBENV_SHIMS"
fi

update_github_repo "$RBENV_ROOT" "sstephenson/rbenv"

# Install rbenv plugins
plugins=("sstephenson/ruby-build"
         "sstephenson/rbenv-vars"
         "sstephenson/rbenv-default-gems"
         "sstephenson/rbenv-gem-rehash")

for plugin in ${plugins[@]}; do
  update_github_repo "$RBENV_ROOT/plugins/${plugin##*/}" $plugin
done

# Update path
path=$(path_remove "$RBENV_ROOT/bin" "$RBENV_ROOT/shims")
export PATH="$RBENV_ROOT/bin":$path
