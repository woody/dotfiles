#!/usr/bin/env bash
# Mac OS X Preferences, Inspired by Mathias' legendary .osx

OS_VERSION=$(defaults read /System/Library/CoreServices/SystemVersion ProductVersion);

is_yosemite () {
  [[ $OS_VERSION == 10.10* ]]
}

# General
# Bright appearance
defaults write -g AppleAquaColorVariant -int 1

# Dark theme on Yosemite
is_yosemite && { defaults write -g AppleInterfaceStyle -string "Dark"; }

# Highlight color value are subtly difference on certain OS X
is_yosemite && { # Red color
  defaults write -g AppleHighlightColor -string "1.000000 0.733333 0.721569"
} || {
  defaults write -g AppleHighlightColor -string "1.000000 0.694100 0.549000"; }

# Medium sidebar icon size
defaults write -g NSTableViewDefaultSizeMode -int 2
# Enable menu bar transparency
defaults write -g AppleEnableMenuBarTransparency -bool true
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
