module Unitwise
  class Scale
    attr_reader :value

    include Unitwise::Composable

    def initialize(value, unit)
      @value = value
      if unit.is_a?(Unit)
        @unit = unit.dup
      else
        @unit = Unit.new(unit.to_s)
      end
    end

    def dup
      self.class.new(value, unit)
    end

    def atoms
      unit.atoms
    end

    def special?
      unit.special?
    end

    def functional(value, direction=1)
      unit.functional(value, direction)
    end

    def scalar
      value * unit.scalar
    end

    def unit
      @unit ||= Unit.new(@unit_code)
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

    def to_s
      "#{value} #{unit}"
    end

    def inspect
      "<#{self.class} #{to_s}>"
    end

  end
end