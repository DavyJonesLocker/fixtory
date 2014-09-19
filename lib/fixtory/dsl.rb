module Fixtory::DSL
  def self.build_from(path)
    builder = Fixtory::DSL::Builder.new
    builder._eval_from_fixtory_file(path)
    builder
  end
end

require 'fixtory/dsl/builder'
