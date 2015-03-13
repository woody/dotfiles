#!/usr/bin/env bash

# Manage multiple-versions ruby envoriments by rbenv

# Clean up brewed rbenv
clean_up_brewed_packages rbenv

# Looking for rbenv local repo root
if [ -z "$RBENV_ROOT" ]; then
  export RBENV_ROOT="$HOME/.plugins/rbenv"
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
