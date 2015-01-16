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

# Show scroll bars automatically
defaults write -g AppleShowScrollBars -string Automatic

# Jump to spot that clicked
defaults write -g AppleScrollerPagingBehavior -bool true

# Ask to keep changes when closing documents
defaults write -g NSCloseAlwaysConfirmsChanges -bool true

# Close windows when quitting an application
defaults write -g NSQuitAlwaysKeepsWindows -bool false

# Enable menu bar transparency
defaults write -g AppleEnableMenuBarTransparency -bool true

# Enable swipe between pages
defaults write -g AppleEnableSwipeNavigateWithScrolls -bool true

# Enable mouse swipe navigate with scroll
defaults write -g AppleEnableMouseSwipeNavigateWithScrolls -bool true

# Set Gregorian calendar and week start at Monday
defaults write -g AppleFirstWeekday -dict-add gregorian -int 2

# Use metric units
defaults write -g AppleMetricUnits -bool true

# Set system preferred language to English and region at China
defaults write -g AppleLocale -string en_CN

# Enable double-click a window's title bar to minimize
defaults write -g AppleMiniaturizeOnDoubleClick -bool true

# Short key repeat delay
defaults write -g InitialKeyRepeat -int 15

# Key repeat flash
defaults write -g KeyRepeat -int 0

# Keyboard -> Text -> Use smart quotes and dashes
# Enable smart dash substitution
defaults write -g NSAutomaticDashSubstitutionEnabled -bool true
# Enable smart quote substitution
defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool true

# Keyboard -> Text -> Correct spelling automatically
# Disable auto correct spelling
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
defaults write -g WebAutomaticSpellingCorrectionEnabled -bool false

# Mouse tracking pointer speed.
defaults write -g com.apple.mouse.scaling -float 0.6785

# Disable F1, F2, etc with special function. Combine fn key with special function
defaults write -g com.apple.keyboard.fnState -bool true

# Enable spring-loaded folders and windows
defaults write  -g com.apple.springing.enabled -bool true

# Spring-loaded no delay
defaults write -g com.apple.springing.delay -float 0.0

# Dock
#
# Disable auto hide Dock
defaults write com.apple.dock autohide -bool false

# Dock icon size 38 * 38
defaults write com.apple.dock tilesize -float 38.0

# Enable Dock icon magnification
defaults write com.apple.dock magnification -bool true

# Magnification icon size to 56 * 56
defaults write com.apple.dock largesize -float 56.0

# Enable minimize windows into application icon
defaults write com.apple.dock minimize-to-application -bool true

# Position on screen bottom
defaults write com.apple.dock orientation bottom

# Disable bounces when launching application and less visually distracting.
defaults write com.apple.dock launchanim -bool false

# Xcode
{ # Xcode installed?
  defaults read -app Xcode >/dev/null 2>/dev/null
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
