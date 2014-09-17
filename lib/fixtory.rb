require "fixtory/version"

module Fixtory
  def self.path
    unless @path
      if File.exist?('test/fixtories')
        @path = 'test/fixtories'
      elsif File.exist?('spec/fixtories')
        @path = 'spec/fixtories'
      end
    end

    @path
  end

  def self.path=(path)
    @path = path
  end

  def self.path_for(group_name)
    File.join(path, "#{group_name}.rb")
  end
end

require 'fixtory/dsl'
