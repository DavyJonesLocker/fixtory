require 'fixtory/dsl/row'

class Fixtory::DSL::Table
  attr_accessor :name

  def initialize(name, &block)
    @name = name.to_s
    @rows = []
    instance_eval &block
  end

  def to_hash
    @rows.inject({}) do |hash, row|
      hash[row.instance_variable_get(:@name)] = row.instance_variable_get(:@attributes)
      hash
    end
  end

  def row(name, &block)
    @rows << Fixtory::DSL::Row.new(name, &block)
  end
end
