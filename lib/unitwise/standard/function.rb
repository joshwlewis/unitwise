module Unitwise::Standard
  class Function

    attr_accessor :attributes

    def initialize(attributes)
      @attributes = attributes
    end

    def name
      attributes["function"]["@name"]
    end

    def value
      attributes["function"]["@value"]
    end

    def unit
      attributes["function"]["@Unit"]
    end

    def primary
      attributes["@Unit"]
    end

    def secondary
      attributes["@UNIT"]
    end

    def to_hash
      {name: name, value: value, unit: unit, primary: primary, secondary: secondary}
    end

  end
end