#!/usr/bin/env bash

export GIT_INCLUDED=true

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

update_github_repo () {
  update_git_repo $1 "https://github.com/${2}.git"
}
