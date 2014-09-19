require 'fixtory/dsl/table'

class Fixtory::DSL::Builder < BasicObject
  attr_accessor :_tables

  def initialize
    @_tables = []
  end

  def to_hash
    _tables.inject({}) do |hash, table|
      hash[table._name] = table.to_hash
      hash
    end
  end

  def _table(name, &block)
    _tables << ::Fixtory::DSL::Table.new(name, self, &block)
  end

  def _eval_from_fixtory_file(path)
    contents = ::File.read(path)
    instance_eval(contents, path, 1)
    _tables.each { |table| table.instance_eval(&table._block) }
  end

  def _insert
    _tables.each do |table|
      table._rows.each do |row|
        _connection.insert_fixture(row.instance_eval('@attributes'), table._name)
      end
    end
  end

  def method_missing(method, *args, &block)
    if block && block.respond_to?(:call)
      _table(method, &block)
    else
      table = _tables.find do |table|
        table._name == method.to_s
      end

      table || super
    end
  end

  private

  def _connection
    ::ActiveRecord::Base.connection
  end
end
