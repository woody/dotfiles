#!/usr/bin/env bash
#
# Make sure local dependencies are satisfied.
#

set -e
set -u

rm .bundle/config

{ BUNDLE=`which bundle`
} || {
  echo "Bundler is required, run ./gems.sh make sure Bundler is satisfied."
  exit 1
}

# $@ at end and make sure accpect user specified arguments
$BUNDLE install --binstubs bin --path .bundle --quiet "$@"