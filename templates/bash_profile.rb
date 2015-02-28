#!/usr/bin/env ruby
# Bash profile template

require "erb"
require "Date"

module Templates
  class BashProfile

    @@path = "#{ENV["HOME"]}/.bash_profile"

    def initialize(&block)
      if block_given?
        yield self
      end
    end

    def render()
      ERB.new(<<-"EOF", 0, "<>").result(binding)
        # Generated @ <%= Date.today %>

        export PATH=./bin:/usr/local/bin:$(getconf PATH)

        { type -P pyenv >/dev/null; } && {
          eval "$(pyenv init -)"
        }

        { type -P rbenv >/dev/null; } && {
          eval "$(rbenv init -)"
        }

        # Brew related
        { type -P brew >/dev/null; } && {
          [ -f $(brew --prefix nvm)/nvm.sh ] && {
            source $(brew --prefix nvm)/nvm.sh
            export NVM_DIR=~/.nvm
          }

          [ -f $(brew --prefix)/etc/bash_completion ] && {
            source $(brew --prefix)/etc/bash_completion
          }
        }

        [[ -f ~/.bashrc ]] && {
          source ~/.bashrc
        }
        EOF
    end

    def save(path=nil)
      path = @@path unless path
      File.open(path, "w+") { |f|
        f.write(render)
      }
    end

  end
end
