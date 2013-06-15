module Unitwise
  class Measurement
    attr_reader :value

    include Unitwise::Composable

    def initialize(value, unit)
      @value = value
      if unit.is_a?(String)
        @unit_code = unit
      else
        @unit = unit
      end
    end

    def unit
      @unit ||= Unit.new @unit_code
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

    def to(unit_code)
      other_unit = Unit.new(unit_code)
      if similar_to?(other_unit)
        self.class.new(scale / other_unit.scale, other_unit)
      else
        raise ArgumentError, "Can't coerce #{other_unit} to #{self}."
      end
    end

    def *(other)
      if other.is_a?(Numeric)
        self.class.new(value * other, unit)
      elsif similar_to?(other)
        converted = other.to(unit)
        self.class.new(value * converted.value, unit * converted.unit)
      else
        self.class.new(value * other.value, unit * other.unit)
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