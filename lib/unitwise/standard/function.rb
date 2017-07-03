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
      Unitwise::Number.simplify(attributes["function"]["@value"])
    end

    def unit
      attributes["function"]["@Unit"]
    end

    def primary
      attributes["@Unit"].gsub(/\(.*\)/, '')
    end

    def secondary
      attributes["@UNIT"]
    end

    def to_hash
      {:function_code => primary, :value => value, :unit_code => unit}
    end

  end
end
