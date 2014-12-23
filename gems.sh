#!/bin/sh

# Exit immediate while error occurred
set -e

function abort () {
  echo "$1"
  exit 1
}

# RubyGem for development.
# - Cocoapods    Manage Objective-C project dependencies.
# - Bundler      Manage Ruby application dependencies.

function gem () {
  local GEM="$(/usr/bin/which gem)"

  ( $GEM list -i "$1" >/dev/null ) || {
    /usr/bin/sudo -E -p "Install $1 for system ruby and require password: " \
    $GEM install "$1"
  }

  echo -e "\xE2\x9C\x94\xEF\xB8\x8E $1"
}

# Make sure RubyGem installed properly.
( [ -x /usr/bin/gem ] ) || {
  abort "Couldn't found RubyGem," \
  "please make sure that is installed."
}

gem "cocoapods"
gem "bundler"
