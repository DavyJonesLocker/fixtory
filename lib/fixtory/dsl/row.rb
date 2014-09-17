class Fixtory::DSL::Row
  def initialize(name, &block)
    @name = name.to_s
    @attributes = {}
    instance_eval &block
  end

  def method_missing(attribute, *args)
    if args.first
      @attributes[attribute.to_s] = args.first
    else
      @attributes[attribute.to_s]
    end
  end
end
