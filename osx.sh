#!/usr/bin/env bash
# Mac OS X Preferences, Inspired by Mathias' legendary .osx

# Xcode
{ # Xcode installed?
  defaults read -app Xcode >/dev/null &2>/dev/null
} && {
  # Show line number
  defaults write -app Xcode DVTTextShowLineNumbers -bool true

  # 80 columns vertical ruler
  defaults write -app Xcode DVTTextShowPageGuide -bool true
  defaults write -app Xcode DVTTextPageGuideLocation -int 80

  # Disable code folding
  defaults write -app Xcode DVTTextShowFoldingSidebar -bool false
  defaults write -app Xcode DVTTextCodeFocusOnHover -bool false

  # Highlight selected symbols at file scope
  defaults write -app Xcode DVTTextAutoHighlightTokens -bool true

  # Enable completions suggestion manually
  defaults write -app Xcode DVTTextAutoSuggestCompletions -bool false
  defaults write -app Xcode DVTTextShowCompletionsOnEsc -bool true

  # Auto-complete punctuation mark
  defaults write -app Xcode DVTTextEnableTypeOverCompletions -bool true
  defaults write -app Xcode DVTTextAutoInsertCloseBrace -bool true
  defaults write -app Xcode DVTTextAutoInsertOpenBracket -bool true

  # Trim whitespace
  defaults write -app Xcode DVTTextEditorTrimTrailingWhitespace -bool true
  defaults write -app Xcode DVTTextEditorTrimWhitespaceOnlyLines -bool true

  # Convert Tabs to Spaces
  defaults write -app Xcode DVTTextIndentUsingTabs -bool false

  # Soft-wrap line
  defaults write -app Xcode DVTTextEditorWrapsLines -bool true

}
