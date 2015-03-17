#!/usr/bin/env bash
# Link all file end with .symlink to $HOME

if [ -z $DOTFILES ]; then
  DOTFILES="$HOME/.dotfiles"
fi

for src in $(pwd)/*.symlink; do
  dest="$HOME/.$(basename "${src%%.symlink}")"
  ln -sf "$src" "$dest"
done
