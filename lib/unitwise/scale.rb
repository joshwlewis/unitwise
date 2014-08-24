module Unitwise
  # A Unitwise::Scale represents a value and a unit, sort of like a vector, it
  # has two components. In this case, it's a value and unit rather than a
  # magnitude and direction. This class should be considered mostly privateish.
  class Scale
    liner :value, :unit
    include Unitwise::Compatible

    def initialize(value, unit)
      self.value = if value.is_a? self.class
        value.convert_to(unit).value
      else
        value
      end
      self.unit = unit
      freeze
    end

    # Set the unit vector.
    # @param value [String, Unitwise::Unit]
    # @api public
    def unit=(value)
      @unit = value.is_a?(Unit) ? value : Unit.new(value)
    end

    # List the atoms associated with this scale's unit.
    # @return [Array]
    # @api public
    def atoms
      unit.atoms
    end

    def value=(value)
      @value = BigDecimal(value.to_s)
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
    memoize :root_terms

    # How far away is this instances unit from the deepest leve atom.
    # @return [Integer]
    # @api public
    def depth
      unit.depth + 1
    end
    memoize :depth

    # Attempts to coerce the value to the simplest Numeric that fully expresses
    # it's value. For instance a value of 1.0 would return 1, a value of
    # #<BigDecimal:7f9558d559b8,'0.45E1',18(18)> would return 4.5.
    # @return [Numeric]
    # @api public
    def simplified_value
      if value.is_a?(Integer)
        value
      elsif (i = Integer(value)) == value
        i
      elsif value.is_a?(Float) || value.is_a?(Rational)
        value
      elsif (f = Float(value)) == value
        f
      else
        value
      end
    end
    memoize :simplified_value

    def expression
      unit.expression
    end

    # Convert to a simple string representing the scale.
    # @api public
    def to_s(mode = nil)
      "#{simplified_value} #{unit.to_s(mode)}"
    end

    def inspect
      "#<#{self.class} value=#{simplified_value} unit=#{unit}>"
    end

    # Redefine hash for apropriate hash/key lookup
    # @api semipublic
    def hash
      [value, unit.to_s, self.class].hash
    end
    memoize :hash

    # Redefine hash equality to match the hashes
    # @api semipublic
    def eql?(other)
      hash == other.hash
    end
  end
end
