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

  def method_missing(method, *args, &block)
    row = @rows.find do |row|
      row.instance_variable_get(:@name) == method.to_s
    end

    row || super
  end
end
