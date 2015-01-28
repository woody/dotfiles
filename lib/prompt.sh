#!/usr/bin/env bash
# Prompt info

success () {
  echo -e "[ \xE2\x9C\x94\xEF\xB8\x8E ] $1"
}

error () {
  echo -e "[ \xE2\x9C\x98 ] $1" >&2
}
