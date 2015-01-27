#!/usr/bin/env bash
# Meet condition

set -e
set -u

require () {
  # Allowed multiple arguments
  (( $# <= 0 )) && {
    # TODO: Usage heredoc
    # e.g cat <HERE
    #
    echo "Missing argument error."
    exit 1
  }

  # Parse argument
  for arg in "$@"; do
    case $arg in
      'homebrew' | 'brew')
        { /usr/bin/which brew >/dev/null; } || {
          echo "$arg not found." >&2
          exit 1; }
        ;;
    esac
  done
}
