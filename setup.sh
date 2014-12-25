#!/usr/bin/env bash
# Setup Mac OSX
#
# More strict
set -u
set -e

# print error message and exit. e.g.
abort () {
  echo -e "$1"
  exit 1
}

# Droid Sans Mono is my favourite font for programming
DROID_INSTALLED_SUCCESSFUL_MSG="Droid Sans Mono is installed."

is_droid_installed () {
  ls "$1" | grep "DroidSansMono" >/dev/null
}

{ # Installed at system-wide?
is_droid_installed /Library/Fonts/
} || { # Installed at user-wide?
is_droid_installed ~/Library/Fonts/
} || { # Download and install
curl http://download.damieng.com/fonts/redistributed/DroidFamily.zip -o /tmp/DroidFamily.zip
unzip /tmp/DroidFamily.zip -d /tmp >>/dev/null && \
cp /tmp/DroidFonts/DroidSansMono.ttf ~/Library/Fonts/
}


# RubyGems for system Ruby and help to development
gem () {
  local GEM='/usr/bin/gem'

  ( $GEM list -i "$1" >/dev/null ) || {
  /usr/bin/sudo -E -p "Install $1 for system ruby and require password: " \
  $GEM install "$1" "$@"
  }
}

( [ -x /usr/bin/gem ] ) || {
  abort "Couldn't found RubyGem," \
  "please make sure that is installed."
}

gem "cocoapods"  # Manage Cocoa (Touch) project dependencies.
gem "bundler"    # Manage Ruby application dependencies.


# Manage Python packages by pip instead of easy_install
{ #pip is installed?
  /usr/bin/which pip >/dev/null
} || { # Install pip
  /usr/bin/sudo -E -p "Install pip for system python and require password: " \
  /usr/bin/easy_install --quiet -s /usr/bin pip 2>/dev/null
}


# Success prompt
success () {
  echo -e "\xE2\x9C\x94\xEF\xB8\x8E $1"
}

success "Droid Sans Mono - My favourite programming font."
success "Cocoapods - Manage Cocoa (Touch) project dependencies."
success "Bundler - Manage Ruby application dependencies."
success "pip - Manage Python packages by pip instead easy_install."
