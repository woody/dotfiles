#!/usr/bin/env bash
# Manage OSX missing ackage by homebrew

set -e
set -u


reportSuccess () {
  local successIssuesCount=${#successIssues[@]}
  successIssues[$(( successIssuesCount + 1))]="$1"
}

reportFail () {
  local failIssuesCount=${#failIssues[@]}
  failIssues[$(( failIssuesCount + 1))]="$1"
}

# I think this should be call at top
# make sure /usr/local/bin at PATH for installing homebrew
{ ruby -e 'abort unless ENV["PATH"].split(":").include? "/usr/local/bin"'; } \
|| export PATH=/usr/local/bin:$PATH

# homebrew manage OSX missing packages
# homebrew installed?
{ type -P brew >/dev/null; } || {
  # Install homebrew
  ruby -e \
  "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" || {
    reportFail homebrew
    false
  }
} && {
  reportSuccess homebrew
}
