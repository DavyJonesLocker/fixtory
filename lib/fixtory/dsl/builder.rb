require 'fixtory/dsl/table'

class Fixtory::DSL::Builder
  def initialize
    @tables = []
  end

  def to_hash
    @tables.inject({}) do |hash, table|
      hash[table.name] = table.to_hash
      hash
    end
  end

  def table(name, &block)
    @tables << Fixtory::DSL::Table.new(name, &block)
  end

  def eval_from_fixtory_file(path)
    contents = File.read(path)
    instance_eval(contents, path, 1)
  end

  def insert
    @tables.each do |table|
      table.rows.each do |row|
        connection.insert_fixture(row.instance_variable_get(:@attributes), table.name)
      end
    end
  end

  def method_missing(method, *args, &block)
    table = @tables.find do |table|
      table.instance_variable_get(:@name) == method.to_s
    end

    table || super
  end

  private

  def connection
    ActiveRecord::Base.connection
  end
end

