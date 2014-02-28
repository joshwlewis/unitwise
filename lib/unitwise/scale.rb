module Unitwise
  # A Unitwise::Scale represents a value and a unit, sort of like a vector, it 
  # has two components. In this case, it's a value and unit rather than a
  # magnitude and direction. This class should be considered mostly privateish.
  class Scale < Liner.new(:value, :unit)
    include Unitwise::Composable

    # The unit associated with this scale.
    # @return [Unitwise::Unit]
    # @api public
    def unit
      @unit.is_a?(Unit) ? @unit : Unit.new(@unit)
    end

    # Duplicate this instance
    # @return [Unitwise::Unit]
    # @api public
    def dup
      self.class.new(value, unit)
    end

    # List the atoms associated with this scale's unit.
    # @return [Array]
    # @api public
    def atoms
      unit.atoms
    end

    # List the atoms associated with this scale's unit.
    # @return [Array]
    # @api public
    def terms
      unit.terms
    end

    # Is this scale's unit special?
    # @return [true, false]
    # @api public
    def special?
      unit.special?
    end

    # Return a converted value for this scale, based on it's function for
    # scales with special units.
    # @param x [Numeric] Value to convert to or from
    # @param forward [true, false] whether to convert to this unit or from it.
    # @return [Numeric]
    # @api public
    def functional(x=value, forward=true)
      unit.functional(x, forward)
    end

    # Return a scalar value for non-special units, this will be some ratio of a
    # child base unit.
    # @return [Numeric]
    # @api public
    def scalar
      value * unit.scalar
    end

    # The base units this scale's unit is derived from
    # @return [Array] An array of Unitwise::Term
    # @api public
    def root_terms
      unit.root_terms
    end

    # How far away is this instances unit from the deepest leve atom.
    # @return [Integer]
    # @api public
    def depth
      unit.depth + 1
    end

    # Is this the deepest level scale in the scale chain?
    # @return [true, false]
    # @api public
    def terminal?
      depth <= 3
    end

    # Convert to a simple string representing the scale.
    # @api public
    def to_s
      "#{value} #{unit}"
    end

  end
end