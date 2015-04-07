#!/usr/bin/env bash

# Manage multiple-versions ruby envoriments by rbenv

if [[ ! $BREW_INCLUDED ]]; then source brew.sh; fi
if [[ ! $GIT_INCLUDED ]]; then source git.sh; fi
if [[ ! $PATH_INCLUDED ]]; then source path.sh; fi


# Manually install rbenv instead of brewed
remove_brewed_packages rbenv

# Remove existing rbenv from PATH
RBENV_PATH=$(type -P rbenv)

[[ $RBENV_PATH ]] && {
  path_remove $(dirname "$RBENV_PATH")
}

# Looking for rbenv local repo root
if [ -z "$RBENV_ROOT" ]; then
  export RBENV_ROOT="$HOME/.dotfiles/.plugins/rbenv"
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
path=$(path_remove "$RBENV_ROOT/bin")
export PATH="$RBENV_ROOT/bin":$path
