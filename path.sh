#!/usr/bin/env bash

export PATH_INCLUDED=true

# Remove an entry from $PATH
# Based on http://stackoverflow.com/a/2108540/142339
# Steal from cowboy/dotfiles
function remove_path() {
  local arg path
  path=":$PATH:"
  for arg in "$@"; do path="${path//:$arg:/:}"; done
  path="${path%:}"
  path="${path#:}"
  echo "$path"
}
