require 'fixtory/dsl/row'

class Fixtory::DSL::Table
  attr_accessor :_name
  attr_accessor :_builder
  attr_accessor :_rows
  attr_accessor :_model_class
  attr_accessor :_block

  def initialize(name, builder, &block)
    @_name = name.to_s
    @_builder = builder
    @_rows = []
    @_block = block
  end

  def to_hash
    _rows.inject({}) do |hash, row|
      hash[row.instance_eval('@name')] = row.instance_eval('@attributes')
      hash
    end
  end

  def _model_class
    @_model_class ||= _name.singularize.camelize.constantize
  end

  def _row(name, &block)
    _rows << ::Fixtory::DSL::Row.new(name, self, &block)
  end

  def method_missing(method, *args, &block)
    if block && block.respond_to?(:call)
      _row(method, &block)
    else
      method = method.to_s

      row = _rows.find do |row|
        row.instance_eval('@name') == method
      end

      if row != nil
        _model_class.find(row.id)
      else
        super
      end
    end
  end
end
