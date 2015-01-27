#!/usr/bin/env bash
# Homebrew formula

set -e
set -u


require_brew () {
  (( $# > 0 )) && {
    echo "Expect zero agrument" >&2
    exit 1
  }

  # homebrew installed?
  { /usr/bin/which brew >/dev/null; } || {
    #   # Install hombrew
    /usr/bin/sudo -E -p "Require password to install homebrew: " \
    /usr/bin/mkdir -p /usr/local && {
      $(/usr/bin/which ruby) -e \
      "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    }
  } && { # Extend homebrew
    taps () {
      for t in "$@"; do
        brew tap "$t" 2>/dev/null
      done
    }

    taps "caskroom/cask" \
          "homebrew/binary" \
          "homebrew/completions" \
          "homebrew/dupes"

    { brew cask >/dev/null; } || {
      brew install caskroom/cask/brew-cask
    }
  }
}

formula () {
  # Declare homebrew formula
  # Require homebrew installed
  require_brew

  for f in "$@"; do
    # Formula is installed?
    { $(/usr/bin/which brew) list | grep "$f" >/dev/null; } || {
      # Install formula
      $(/usr/bin/which brew) install "$f"
    }
  done
}
