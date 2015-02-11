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

    def render()
      ERB.new(<<-"EOF").result(binding)
        <%# Include /usr/local/bin to $PATH %>
        <% if local_bin_in_path? %>
          export PATH=<%= ENV["PATH"] %>
        <% else %>
          export PATH=/usr/local/bin:<%= ENV["PATH"] %>
        <% end %>
      EOF
    end

    def save(path=nil)

    end

  end
end
