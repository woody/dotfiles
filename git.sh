#!/usr/bin/env bash

set -e
set -u

# Install latest git via homebrew
BREWED_GIT=$FALSE

formula git && BREWED_GIT=$TRUE

# Global gitignore
GITIGNORE_LOCAL_REPO=~/.gitignore-templates
GITIGNORE_REMOTE_REPO="https://github.com/github/gitignore"

if [ -e $GITIGNORE_LOCAL_REPO/.git ]
  then
    cd $GITIGNORE_LOCAL_REPO
    { # github/gitignore repo?
      [[ $(git config --get remote.origin.url) = $GITIGNORE_REMOTE_REPO ]]
    } && { # Pull and be quite
      git checkout -q master
      git pull origin master > /dev/null 2>/dev/null
    } || { # Back up to ~/old-gitignore.d and clone
      cd .. && mv -f $GITIGNORE_LOCAL_REPO ~/old_gitignore-templates && \
      git clone -q $GITIGNORE_REMOTE_REPO $GITIGNORE_LOCAL_REPO
    }
else
  git clone -q $GITIGNORE_REMOTE_REPO $GITIGNORE_LOCAL_REPO
fi

git_ignore () {
  # Dump git ignore patterns of specified type
  # e.g git_ignore OSX Xcode vim >>~/.gitignore_global
  #
  local GLOBAL_GITIGNORE="$GITIGNORE_LOCAL_REPO/Global"

  while (( "$#" )); do
    if [ -f $GLOBAL_GITIGNORE/$1.gitignore ]; then
      echo "# $1"
      echo "# ------"
      cat $GLOBAL_GITIGNORE/$1.gitignore
      echo
    elif [ -f $GITIGNORE_LOCAL_REPO/$1.gitignore ]; then
      echo "# $1"
      echo "#------"
      cat $GITIGNORE_LOCAL_REPO/$1.gitignore
      echo
    fi
    shift
  done
}

GLOBAL_GITIGNORE=$FALSE
GLOBAL_GITIGNORE_MSG='Set ~/.gitignore_global.'

# Add template to ~/.gitignore_global
git_ignore Xcode vim SublimeText Archives Tags \
           Vagrant VirtualEnv OSX >~/.gitignore_global && \
GLOBAL_GITIGNORE=$TRUE

# Prompt
[ $BREWED_GIT -eq $TRUE ] && \
{ GIT_VERSION=$(`/usr/bin/which git` --version)
  success "Upgrade $GIT_VERSION."
}
[ $GLOBAL_GITIGNORE -eq $TRUE ] && success $GLOBAL_GITIGNORE_MSG || \
fail $GLOBAL_GITIGNORE_MSG

git config --global core.excludesfile ~/.gitignore_global
git config --global core.editor vim
git config --global core.whitespace \
tralling-space,space-before-tab,tab-in-indent
git config --global core.autocrlf input
git config --global push.default simple
git config --global color.ui auto
git config --global include.path ~/.gitconfig_user

# Install Tower.app command-line utility
declare TOWER_CLI
SYS_TOWER_CLI=/Applications/Tower.app/Contents/MacOS/gittower
USER_TOWER_CLI=~/Applications/Tower.app/Contents/MacOS/gittower

if ! [ -d $SYS_TOWER_CLI ] && [ -x $SYS_TOWER_CLI ]; then
  TOWER_CLI=$SYS_TOWER_CLI
elif ! [ -d $USER_TOWER_CLI ] && [ -x $USER_TOWER_CLI ]; then
  TOWER_CLI=$USER_TOWER_CLI
fi

if [ -n $TOWER_CLI ]; then
  /bin/ln -fs $TOWER_CLI /usr/local/bin/gittower && \
  success "Install Tower.app command-line utility."
fi

# Install ksdiff and integrate with git
# Require Kaleidoscope.app installed at system-wide or user-wide
if [ -d /Applications/Kaleidoscope.app ] || [ -d ~/Applications/Kaleidoscope.app ]; then

  integrate_ksdiff () {
    if (( $# )); then error "No arguments expected."; fi
  }

  install_ksdiff  () {
    if (( $# )); then error "No arguments expected."; fi

    /usr/bin/sudo -E -p "Require password for installing ksdiff " \
    $(/usr/bin/which installer) -pkg /tmp/ksdiff-latest/Install\ ksdiff.pkg \
    -target LocalSystem >/dev/null
  }

  # ksdiff is installed?
  [ -x /usr/local/bin/ksdiff ] && {
    integrate_ksdiff
  } || { # Install ksdiff
    # latest ksdiff installation program exists on local?
    [ -e "/tmp/ksdiff-latest/Install ksdiff.pkg" ] && {
      install_ksdiff && integrate_ksdiff
    } || { # Download latest ksdiff installation program and integration
      TMP_KSDIFF_ARCHIVE=/tmp/ksdiff-latest.zip
      $(/usr/bin/which curl) -s -o $TMP_KSDIFF_ARCHIVE -L \
      https://updates.blackpixel.com/latest?app=ksdiff && \
      $(/usr/bin/which unzip) -q $TMP_KSDIFF_ARCHIVE -d /tmp/ksdiff-latest && \
      install_ksdiff && integrate_ksdiff
    }
  }
fi
