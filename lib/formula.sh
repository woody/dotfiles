#!/usr/bin/env bash
# Homebrew formula

set -e
set -u

source $DOTFILES_LOCAL/lib/prompt.sh

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
  } && {
    [[ -x $(brew --prefix)/bin/brew-cask ]] || {
      brew install caskroom/cask/brew-cask
    }

    taps () {
      # taps function allowed multiple arguments
      for t in "$@"; do
        { brew tap | /usr/bin/grep "$t" >/dev/null; } || {
          { # tap external formula repo
            echo "Tapping $t..."
            brew tap "$t" 2>/dev/null
          } || {
            # tap fail and prompt error
            error "tap $t"
            false
          }
        } && {
          # prompt tap succes
          success "tap $t"
        }
      done
    }

    # Extend homebrew formula repo
    taps  "caskroom/cask" \
          "homebrew/binary" \
          "homebrew/completions" \
          "homebrew/dupes"
  }
}

formula () {
  # Declare homebrew formula
  # Require homebrew installed
  require_brew

  for f in "$@"; do
    # Formula installation options following formula name.
    # Extract formula name
    local name=$(/bin/echo $f | /usr/bin/awk '{print $1}')
    # Formula is installed?
    { $(/usr/bin/which brew) list | /usr/bin/grep "$name" >/dev/null; } || {
      # Install formula
      $(/usr/bin/which brew) install "$f"
    }
  done
}

[[ -e $DOTFILES_LOCAL/formulas ]] && {
  source $DOTFILES_LOCAL/formulas
}
