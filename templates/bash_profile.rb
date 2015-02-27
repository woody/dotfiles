#!/usr/bin/env ruby
# Bash profile template

require "erb"

module Templates
  class BashProfile

    @@path = "#{ENV["HOME"]}/.bash_profile"

    def initialize(&block)
      if block_given?
        yield self
      end
    end

    def local_bin_in_path?
      ENV["PATH"].split(":").include?("/usr/local/bin")
    end

    def pyenv_installed?
      test("x", "/usr/local/bin/pyenv")
    end

    def rbenv_installed?
      test("x", "/usr/local/bin/rbenv")
    end

    def render()
      ERB.new(<<-"EOF", 0, "<>").result(binding)
        <% if local_bin_in_path? %>export PATH=<%= ENV["PATH"] %>
        <% else %> export PATH=/usr/local/bin:<%= ENV["PATH"] %>
        <% end %>
        <% if pyenv_installed? %>eval "$(pyenv init -)"
        <% end %>
        <% if rbenv_installed? %>eval "$(rbenv init -)"
        <% end %>
        [[ -f ~/.bashrc ]] && {
          source ~/.bashrc
        }

        [[ -d /usr/local/etc/bash_completion.d ]] && {
          for bash_completion in /usr/local/etc/bash_completion.d/*; do
            source "$bash_completion"
          done
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
