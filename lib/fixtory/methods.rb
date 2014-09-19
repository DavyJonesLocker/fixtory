require 'fixtory/dsl'

module Fixtory::Methods
  def fixtory(group_name)
    builder = Fixtory::DSL.build_from(Fixtory.path_for(group_name))
    builder._insert
    builder
  end
end
