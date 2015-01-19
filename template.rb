#!/usr/bin/env ruby

require "erb"

class Shell

  def initialize(profile_template)
    @template = profile_template
    yield self
  end

  def path
    ENV["PATH"]
  end

  def pyenv_installed?
    ENV.include? "PYENV_INSTALLED"
  end

  def render
    ERB.new(@template, 0, "<>").result(binding)
  end

end

open("./bash_profile.erb") { |f|
  Shell.new(f.read) { |s|
    if File.exist? "~/.bash_profile"
      `mv ~/.bash_profile ~/.bash_profile.backup`
    else
      `touch ~/.bash_profile`
    end

    IO.write("#{ENV["HOME"]}/.bash_profile", s.render)
  }
  f.close
}
