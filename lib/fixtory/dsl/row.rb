require 'active_support/deprecation'
require 'active_support/concern'
require 'active_record/fixtures'

class Fixtory::DSL::Row < BasicObject
  def initialize(name, table, &block)
    @name = name.to_s
    @table = table
    @inserted = false
    @attributes = {
      _primary_key => ::ActiveRecord::FixtureSet.identify(@name)
    }
    instance_eval &block
  end

  def _primary_key
    'id'
  end

  def _primary_key_value
    @attributes[_primary_key]
  end

  def method_missing(attribute, *args)
    attribute = attribute.to_s
    value = args.first

    if value
      if reflection = @table._model_class._reflections[attribute.to_sym]
        attribute = reflection.association_foreign_key
        value = value._primary_key_value
      end

      @attributes[attribute] = value
    else
      if @attributes.key?(attribute)
        @attributes[attribute]
      else
        @table._builder.instance_eval(attribute)
      end
    end
  end
end
