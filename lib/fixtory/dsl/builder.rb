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
end

