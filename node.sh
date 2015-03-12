#!/usr/bin/env bash

# Manage multiple-versions node by nvm

# Clean up brewed nvm
clean_up_brewed_packages nvm

# Looking for nvm local repo root
local_repo=${NVM_DIR:-"$HOME/.nvm"}

remote_repo=https://github.com/creationix/nvm.git

update_git_repo "$local_repo" "$remote_repo"

export NVM_DIR=$local_repo
