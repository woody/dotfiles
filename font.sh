#!/usr/bin/env bash
#
# Install Droid Sans Mono font
#
# More strict
set -e  # Exit immediately while exit status code is non-zero
set -u  # Invoke unset variable occur error

DROID_INSTALLED_SUCCESSFUL_MSG="Droid Sans Mono is installed."

is_droid_installed () {
  # Check whether Droid Sans Mono installed.
  ls "$1" | grep "DroidSansMono" >/dev/null && echo $DROID_INSTALLED_SUCCESSFUL_MSG
}

{ # Installed at System-wide font?
is_droid_installed /Library/Fonts/
} || { # Installed at User-wide font?
is_droid_installed ~/Library/Fonts/
} || { # Download and install
curl http://download.damieng.com/fonts/redistributed/DroidFamily.zip -o /tmp/DroidFamily.zip
unzip /tmp/DroidFamily.zip -d /tmp >>/dev/null && \
cp /tmp/DroidFonts/DroidSansMono.ttf ~/Library/Fonts/
echo $DROID_INSTALLED_SUCCESSFUL_MSG
}