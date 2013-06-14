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

    def to_s
      "#{value} #{unit.to_s}"
    end

    def inspect
      "<#{self.class} #{to_s}>"
    end

  end
end