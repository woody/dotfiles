#!/usr/bin/env bash

# Manage multiple-versions ruby envoriments by rbenv

# Clean up brewed
clean_up_brewed_packages rbenv

# Looking for rebnv local repo root
rbenv=$(type -P rbenv)

[[ $rbenv ]] && {
  # strip trailing bin
  local_repo=${rbenv%%/bin/rbenv}
  if [[ $local_repo = $rbenv ]]; then
    # trailing bin not stripped
    false
  fi
} || local_repo=$HOME/.rbenv

remote_repo=https://github.com/sstephenson/rbenv.git

update_git_repo $local_repo $remote_repo

# Install rbenv plugins
plugins=("rbenv-gem-rehash"
         "rbenv-default-gems"
         "rbenv-vars"
         "ruby-build")

for plugin in ${plugins[@]}; do
  update_git_repo "$local_repo/plugins/$plugin" \
  "https://github.com/sstephenson/$plugin.git"
done

# Update path
path=$(path_remove "$local_repo/bin")
export PATH="$local_repo/bin":$path
