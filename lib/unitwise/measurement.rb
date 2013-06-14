module Unitwise
  class Measurement
    attr_reader :value, :unit_code

    include Unitwise::Composable

    def initialize(value, unit_code)
      @value = value
      @unit_code = unit_code
    end

    def unit
      @unit ||= Unit.new unit_code
    end

    def root_terms
      unit.root_terms
    end

    def depth
      unit.depth + 1
    end

    def terminal?
      depth <= 3
    end

    def scale
      value * unit.scale
    end

    def to(other_unit_code)
      other_unit = Unit.new(other_unit_code)
      if similar_to?(other_unit)
        self.class.new(scale / other_unit.scale, other_unit_code)
      else
        raise ArgumentError, "Units are not similar"
      end
    end

    def *(other)
      if other.is_a?(Numeric)
        self.class.new(value * other, unit_code)
      elsif similar_to?(other)
        converted = other.to(unit_code)
        self.class.new(value * converted.value, "(#{unit_code})2")
      else
        self.class.new(value * other.value, "(#{unit_code}).(#{other.unit_code})")
      end
    end

    def to_s
      "#{value} #{unit.to_s}"
    end

    def inspect
      "<#{self.class} #{to_s}>"
    end

  end
end