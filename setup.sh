#!/usr/bin/env bash
# Setup Mac OSX
#
# More strict
set -u
set -e

# Bool Constant
declare -ri TRUE=1
declare -ri FALSE=0


# Prompt
success () {
  echo -e "\xE2\x9C\x94\xEF\xB8\x8E $@"
}

fail () {
  echo -e "\xE2\x9C\x98 $@"
}

error () {
  echo "!!! $@"
}


# Droid Sans Mono is my favourite font for programming
DROID_FONT_INSTALLED=$FALSE

is_droid_installed () {
  ls "$1" | grep "DroidSansMono" >/dev/null && DROID_FONT_INSTALLED=$TRUE
}

{ # Installed at system-wide?
is_droid_installed /Library/Fonts/
} || { # Installed at user-wide?
is_droid_installed ~/Library/Fonts/
} || { # Download and install
curl http://download.damieng.com/fonts/redistributed/DroidFamily.zip -o /tmp/DroidFamily.zip
unzip /tmp/DroidFamily.zip -d /tmp >>/dev/null && \
cp /tmp/DroidFonts/DroidSansMono.ttf ~/Library/Fonts/ && \
DROID_FONT_INSTALLED=$TRUE
}


# Gems for system Ruby
gem () {
  # Install rubygem
  # $1 specified gem name and following gem install options

  local GEM=`/usr/bin/which gem`

  ( $GEM list -i "$1" >/dev/null ) || {
  /usr/bin/sudo -E -p "Install $1 for system ruby and require password: " \
  $GEM install "$@"
  }
}

PODS_INSTALLED=$FALSE
BUNDLER_INSTALLED=$FALSE

{ # Rubygem is installed?
  /usr/bin/which gem >/dev/null || error "RubyGem not found."
} && { # Install gems for system ruby
  gem "cocoapods" && PODS_INSTALLED=$TRUE
  gem "bundler" && BUNDLER_INSTALLED=$TRUE
}


# Manage Python packages by pip instead of easy_install
PIP_INSTALLED=$FALSE

{ #pip is installed?
  /usr/bin/which pip >/dev/null && PIP_INSTALLED=$TRUE
} || { # Install pip
  /usr/bin/sudo -E -p "Install pip for system python and require password: " \
  /usr/bin/easy_install -s /usr/bin pip 2>/dev/null && \
  PIP_INSTALLED=$TRUE
}


# Homebrew - Mac OSX missing package manager
BREW_INSTALLED=$FALSE

{ # Homebrew is installed?
  /usr/bin/which brew >/dev/null && BREW_INSTALLED=$TRUE
} || { # Install homebrew
/usr/bin/sudo -E -p "Install Homebrew require password: " \
/bin/mkdir -p /usr/local && \
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" && \
BREW_INSTALLED=$TRUE
}


# Description
DROID_FONT_DESC="Droid Sans Mono - My favourite programming font."
BUNDLER_DESC="Bundler - Manage Ruby application dependencies."
PODS_DESC="Cocoapods - Manage Cocoa (Touch) project dependencies."
PIP_DESC="pip - Manage Python packages by pip instead easy_install."
BREW_DESC="Homebrew - Mac OSX missing package manager."


[ $DROID_FONT_INSTALLED -eq $TRUE ] && success ${DROID_FONT_DESC} || fail ${DROID_FONT_INSTALLED}
[ $PODS_INSTALLED -eq $TRUE ] && success ${PODS_DESC} || fail ${PODS_DESC}
[ $BUNDLER_INSTALLED -eq $TRUE ] && success ${BUNDLER_DESC} || fail ${BUNDLER_DESC}
[ $PIP_INSTALLED -eq $TRUE ] && success ${PIP_DESC} || fail ${PIP_DESC}
[ $BREW_INSTALLED -eq $TRUE ] && success ${BREW_DESC} || fail ${BREW_DESC}
