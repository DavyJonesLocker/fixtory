require 'active_support/deprecation'
require 'active_support/concern'
require 'active_record/fixtures'

class Fixtory::DSL::Row < BasicObject
  def initialize(name, table, &block)
    @name = name.to_s
    @table = table
    @attributes = {
      'id' => ::ActiveRecord::FixtureSet.identify(@name)
    }
    instance_eval &block
  end

  def method_missing(attribute, *args)
    attribute = attribute.to_s

    if args.first
      @attributes[attribute] = args.first
    else
      if @attributes.key?(attribute)
        @attributes[attribute]
      else
        @table._builder.instance_eval(attribute)
      end
    end
  end
end
