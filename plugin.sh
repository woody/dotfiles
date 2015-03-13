#!/usr/bin/env bash

if [ -z "$DOTPLUGINS" ]; then
  DOTPLUGINS="$HOME/.plugins"
fi

mkdir -p "$DOTPLUGINS"
