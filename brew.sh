#!/usr/bin/env bash
# Manage OSX missing ackage by homebrew

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
    echo "Homebrew installed fails!!!" >&2
    return 1
  }
} && {
  reportSuccess homebrew
}

# Extend official homebrew by brew tap
extend_brew_formulas () {
  for repo in ${formuals_repos[@]}; do
    [[ $(brew tap | grep "$repo") ]] || {
      brew tap $repo || {
        reportFail "$repo"
        false
      }
    } && {
      reportSuccess "$repo"
    }
  done
}

# Install homebrew formulas
install_brew_formulas () {
  for formula in "${formulas[@]}"; do
    [[ -d $(brew --cellar $formula) ]] || {
      brew install $formula || {
        reportFail "$formula"
        false
      }
    } && {
      reportSuccess "$formula"
    }
  done
}

remove_brewed_packages () {
  # Allowed mutiple packages
  while (( $# )); do
    if [ -d "$(brew --cellar $1)" ]; then brew remove $1; fi
    shift
  done
}
