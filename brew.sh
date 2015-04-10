#!/usr/bin/env bash
# Manage OSX missing ackage by homebrew

set -e

export BREW_INCLUDED=true

reportSuccess () {
  local successIssuesCount=${#successIssues[@]}
  successIssues[$(( successIssuesCount + 1))]="$1"
}

reportFail () {
  local failIssuesCount=${#failIssues[@]}
  failIssues[$(( failIssuesCount + 1))]="$1"
}

# Install homebrew
if [ -z "$(type -P brew)" ]; then
  ruby -e \
  "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Extend official homebrew by brew tap
extend_brew_formulas () {
  for repo in ${formuals_repos[@]}; do
    [[ $(brew tap | grep "$repo") ]] || {
      brew tap $repo || {
        reportFail "$repo"
        false
      }
    } && {
      reportSuccess "$repo"
    }
  done
}

# Install packages via homebrew
install_brew_packages () {
  while (( $# )); do
    brew insall $1
    shift
  done
}

remove_brewed_packages () {
  # Allowed mutiple packages
  while (( $# )); do
    if [ -d "$(brew --cellar $1)" ]; then brew remove $1; fi
    shift
  done
}
