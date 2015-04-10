#!/usr/bin/env bash
# Manage OSX missing ackage by homebrew

set -e

export BREW_INCLUDED=true

# Install homebrew
if [ -z "$(type -P brew)" ]; then
  ruby -e \
  "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Extend brew offcial formulas repos
extend_brew_repos () {
  while (( $# )); do
    { brew tap | grep "$1"; } || {
      brew tap $1
    }
    shift
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
