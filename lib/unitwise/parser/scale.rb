module Unitwise::Parser
  class Scale
    attr_accessor :nori

    def initialize(nori)
      @nori = nori
    end

    def value
      nori.attributes["value"]
    end

    def primary_unit
      nori.attributes["Unit"]
    end

    def secondary_unit
      nori.attributes["UNIT"]
    end

    def to_hash
      {value: value, primary_unit: primary_unit, secondary_unit: secondary_unit}
    end
  end
end