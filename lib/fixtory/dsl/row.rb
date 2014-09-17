class Fixtory::DSL::Row
  def initialize(name, &block)
    @name = name.to_s
    @attributes = {}
    instance_eval &block
  end

  def method_missing(attribute, value)
    if value
      @attributes[attribute.to_s] = value
    else
      @attributes[attribute.to_s]
    end
  end
end
