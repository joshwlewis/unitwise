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

    def *(other)
      if other.is_a?(Numeric)
        self.class.new(value * other, unit_code)
      elsif [:value, :unit, :to].all?{|m| other.respond_to?(m)}
        if similar_to?(other)
          converted = other.to(unit_code)
          self.class.new(value * converted.vale, unit * other.unit)
        else
          self.class.new(value * other.value, unit * other.unit)
        end
      else
        raise ArgumentError
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