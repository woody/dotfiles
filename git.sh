#!/usr/bin/env bash

update_git_repo () {
  # Is it git repo?
  if [ -d "$1"/.git ]; then
    cd $1
  else
    mkdir -p $1 && cd $1
    git init && git remote add origin $2
  fi

  git pull origin master

  # Back to original
  cd - >>/dev/null
}
