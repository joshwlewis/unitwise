module Unitwise
  # A Unitwise::Scale represents a value and a unit, sort of like a vector, it
  # has two components. In this case, it's a value and unit rather than a
  # magnitude and direction. This class should be considered mostly privateish.
  class Scale
    liner :value, :unit

    include Unitwise::Compatible

    def initialize(*args)
      super(*args)
      freeze
    end

    # The unit associated with this scale.
    # @return [Unitwise::Unit]
    # @api public
    def unit
      @unit.is_a?(Unit) ? @unit : Unit.new(@unit)
    end

    # List the atoms associated with this scale's unit.
    # @return [Array]
    # @api public
    def atoms
      unit.atoms
    end

    # List the terms associated with this scale's unit.
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

    # Get a scalar value for this scale.
    # @param magnitude [Numeric] An optional magnitude on this scale.
    # @return [Numeric] A scalar value on a linear scale
    # @api public
    def scalar(magnitude = value)
      if special?
        unit.scalar(magnitude)
      else
        value * unit.scalar
      end
    end

    # Get a magnitude based on a linear scale value. Only used by scales with 
    # special atoms in it's hierarchy.
    # @param scalar [Numeric] A linear scalar value
    # @return [Numeric] The equivalent magnitude on this scale
    # @api public
    def magnitude(scalar = scalar)
      if special?
        unit.magnitude(scalar)
      else
        value * unit.magnitude
      end
    end

    # The base terms this scale's unit is derived from
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

    # Convert to a simple string representing the scale.
    # @api public
    def to_s
      "#{value} #{unit}"
    end

    def inspect
      "#<#{self.class} value=#{value} unit=#{unit}>"
    end

    # Redefine hash for apropriate hash/key lookup
    # @api semipublic
    def hash
      [value, unit.to_s, self.class].hash
    end

    # Redefine hash equality to match the hashes
    # @api semipublic
    def eql?(other)
      hash == other.hash
    end
  end
end
