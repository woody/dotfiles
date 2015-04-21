#!/usr/bin/env bash
# OSX package manager

export BREW_INCLUDED=true

# Install homebrew
if [ -z "$(type -P brew)" ]; then
  ruby -e \
  "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

extend_brew_repos () {
  while (( $# )); do
    brew tap $1 2>/dev/null
    shift
  done
}

install_brew_packages () {
  # Allowed multiple packages
  while (( $# )); do
    brew install $1 2>/dev/null
    shift
  done
}

remove_brew_packages () {
  # Allowed multiple packages
  while (( $# )); do
    if [ -d "$(brew --cellar $1)" ]; then brew remove $1; fi
    shift
  done
}

# Install brew cask
# Be quiet
extend_brew_repos caskroom/cask
install_brew_packages brew-cask

export BREW_INSTALLED=true
