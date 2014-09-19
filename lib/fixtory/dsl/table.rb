require 'fixtory/dsl/row'

class Fixtory::DSL::Table
  attr_accessor :name
  attr_accessor :builder
  attr_accessor :rows

  def initialize(name, builder, &block)
    @name = name.to_s
    @builder = builder
    @rows = []
    instance_eval &block
  end

  def to_hash
    @rows.inject({}) do |hash, row|
      hash[row.instance_variable_get(:@name)] = row.instance_variable_get(:@attributes)
      hash
    end
  end

  def model_class
    @model_class ||= @name.singularize.camelize.constantize
  end

  def row(name, &block)
    @rows << Fixtory::DSL::Row.new(name, self, &block)
  end

  def method_missing(method, *args, &block)
    row = @rows.find do |row|
      row.instance_variable_get(:@name) == method.to_s
    end

    if row
      model_class.find(row.id)
    else
      super
    end
  end
end
