require 'fixtory/dsl/row'

class Fixtory::DSL::Table
  attr_accessor :_name
  attr_accessor :_table_name
  attr_accessor :_builder
  attr_accessor :_rows
  attr_accessor :_model_class
  attr_accessor :_block

  def initialize(name, builder, &block)
    @_name = name.to_s
    @_table_name = _model_class.table_name
    @_builder = builder
    @_rows = []
    @_block = block
  end

  def _model_class
    @_model_class ||= _name.singularize.camelize.constantize
  end

  def _row(name, &block)
    row = ::Fixtory::DSL::Row.new(name, self, &block)
    if _sti_table?
      row.instance_eval('@attributes')['type'] = _name.singularize.camelize
    end
    _rows << row
  end

  def method_missing(method, *args, &block)
    if block && block.respond_to?(:call)
      _row(method, &block)
    else
      method = method.to_s

      if @_block
        instance_eval(&_block)
        @_block = nil
      end

      row = _rows.find do |row|
        row.instance_eval('@name') == method
      end

      if row != nil
        if row.instance_eval("@inserted")
          _model_class.find(row._primary_key_value)
        else
          row
        end
      else
        super
      end
    end
  end

  private

  def _sti_table?
    _name != _table_name
  end
end
