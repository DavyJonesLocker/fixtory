require 'fixtory/dsl'

module Fixtory::Methods
  def fixtory(group_name)
    group_name = group_name.to_s

    if Fixtory.identity_map.key?(group_name)
      builder = Fixtory.identity_map[group_name]
      unless builder._inserted
        builder._insert
      end
      builder
    else
      builder = Fixtory::DSL.build_from(Fixtory.path_for(group_name))
      Fixtory.identity_map[group_name] = builder
      builder._insert
      builder
    end
  end
end
