#!/usr/bin/env bash
# Managed Mac packages and application binaries by homebrew

set -e
set -u

source $DOTFILES_LOCAL/lib/private/prompt.sh

# Export formulas declaration
[[ -e $DOTFILES_LOCAL/formulas ]] && {
  source $DOTFILES_LOCAL/formulas
}


# Require homebrew install packages
{ /usr/bin/which brew >/dev/null; } || {

  { # install homebrew
    $(/usr/bin/which ruby) -e \
    "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" \
    >>$DOTFILES_LOG 2>&1
  } || {
    # prompt install homebrew fails
    error "Install homebrew."
    exit
  }
}


# require brew-cask install Mac application
[[ -x $(brew --prefix)/bin/brew-cask ]] || {
  # install brew-cask
  { brew install caskroom/cask/brew-cask >>$DOTFILES_LOG 2>&1; } || {
    # prompt brew-cask install fail
    error "Install brew-cask"
    exit
  }
}


set +u

# extend homebrew external formula repo defined $taps array
[[ $taps ]] && {
  for t in "${taps[@]}"; do
    # Already tapped?
    { brew tap | /usr/bin/grep "$t" >/dev/null; } || {
      echo "Tapping $t..."
      { brew tap "$t" >>$DOTFILES_LOG 2>&1; } || {
        # prompt tap fail
        error "Tap $t"
        false
      }
    } && {
      # prompt tap success
      success "Tap $t"
    }
  done
}

# install formulas defined by $formulas array
[[ $formulas ]] && {
  for f in "${formulas[@]}"; do
    # formula name could followed by installation options
    # Extract formula name
    n=$(/bin/echo $f | /usr/bin/awk '{print $1}')
    # Formula is installed?
    { echo $(brew --prefix $n 2>&1) >/dev/null; } || {
      # Install formula
      echo "Installing $n..."
      { brew install "$f" >>$DOTFILES_LOG 2>&1; } || {
        # prompt formula install fails
        error "Install $n"
        false
      }
    } && {
      # prompt formula install success
      success "Install $n"
    }
  done
}

# install cask defined by $casks array
[[ $casks ]] && {
    for c in "${casks[@]}"; do
    # cask installed?
    { brew cask list 2>/dev/null | grep "$c" >/dev/null; } || {
      # Install cask
      echo "Installing $c..."
      { brew cask install $c >>$DOTFILES_LOG 2>&1; } || {
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
