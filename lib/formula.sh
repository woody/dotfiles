#!/usr/bin/env bash
# Homebrew formula

set -e
set -u

source $DOTFILES_LOCAL/lib/prompt.sh

require_brew () {
  # homebrew installed?
  { /usr/bin/which brew >/dev/null; } || {

    { # install homebrew
      $(/usr/bin/which ruby) -e \
      "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" >/dev/null
    } || {
      # prompt install homebrew fails
      error "Install homebrew."
      exit
    }
  }
}

require_cask () {
  # cask is homebrew for Mac application
  [[ -x $(brew --prefix)/bin/brew-cask ]] || {
    # install brew-cask
    { brew install caskroom/cask/brew-cask >/dev/null; } || {
      # prompt brew-cask install fail
      error "Install brew-cask"
      exit
    }
  }
}

tap () {
  # Tap extend homebrew external formula repo
  require_brew

  # taps function allowed multiple arguments
  for t in "$@"; do
    { brew tap | /usr/bin/grep "$t" >/dev/null; } || {
      { # tap external formula repo
        echo "Tapping $t..."
        brew tap "$t" 2>/dev/null
      } && {
        success "Tap $t"
      } || {
        # tap fail and prompt error
        error "Tap $t"
      }
    }
  done

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
      echo "Installing $name..."
      { $(/usr/bin/which brew) install "$f" >/dev/null; } || {
        # prompt formula install fails
        error "Install $name."
        false
      }
    } && {
      # prompt formula install success
      success "Install $name."
    }
  done
}

cask () {
  # Declare homebrew cask
  require_cask

  for c in "$@"; do
    # cask installed?
    { brew cask list | grep "$c" >/dev/null; } || {
      # Install cask
      echo "Installing $c..."
      { brew cask install $c 2>/dev/null; } || {
        # prompt install cask fail
        error "Install $c"
        false
      }
    } && {
      # prompt cask install success
      success "Install $c"
    }
  done
}


tap "caskroom/cask" \
    "homebrew/binary" \
    "homebrew/completions" \
    "homebrew/dupes"


[[ -e $DOTFILES_LOCAL/formulas ]] && {
  source $DOTFILES_LOCAL/formulas
}
