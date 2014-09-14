module Unitwise
  # A Unit is essentially a collection of Unitwise::Term. Terms can be combined
  # through multiplication or division to create a unit. A unit does not have
  # a magnitude, but it does have a scale.
  class Unit
    liner :expression, :terms
    include Compatible

    # Create a new unit. You can send an expression or a collection of terms
    # @param input [String, Unit, [Term]] A string expression, a unit, or a
    # collection of tems.
    # @api public
    def initialize(input)
      case input
      when Compatible
        @expression = input.expression
      when String, Symbol
        @expression = input.to_s
      else
        @terms = input
      end
    end

    # The collection of terms used by this unit.
    # @return [Array]
    # @api public
    def terms
      unless frozen?
        unless @terms
          decomposer = Expression.decompose(@expression)
          @mode  = decomposer.mode
          @terms = decomposer.terms
        end
        freeze
      end
      @terms
    end

    # Build a string representation of this unit by it's terms.
    # @param mode [Symbol] The mode to use to stringify the atoms
    # (:primary_code, :names, :secondary_code).
    # @return [String]
    # @api public
    def expression(mode=nil)
      if @expression && (mode.nil? || mode == self.mode)
        @expression
      else
        Expression.compose(terms, mode || self.mode)
      end
    end

    # The collection of atoms that compose this unit. Essentially delegated to
    # terms.
    # @return [Array]
    # @api public
    def atoms
      terms.map(&:atom)
    end
    memoize :atoms

    # Is this unit special (meaning on a non-linear scale)?
    # @return [true, false]
    # @api public
    def special?
      terms.count == 1 && terms.all?(&:special?)
    end
    memoize :special?

    # A number representing this unit's distance from it's deepest terminal atom.
    # @return [Integer]
    # @api public
    def depth
      terms.map(&:depth).max + 1
    end
    memoize :depth

    # A collection of the deepest terms, or essential composition of the unit.
    # @return [Array]
    # @api public
    def root_terms
      terms.map(&:root_terms).flatten
    end
    memoize :root_terms

    # Get a scalar value for this unit.
    # @param magnitude [Numeric] An optional magnitude on this unit's scale.
    # @return [Numeric] A scalar value on a linear scale
    # @api public
    def scalar(magnitude = 1.0)
      terms.reduce(1.0) do |prod, term|
        prod * term.scalar(magnitude)
      end
    end

    # Get a magnitude for this unit based on a linear scale value.
    # Should only be used by units with special atoms in it's hierarchy.
    # @param scalar [Numeric] A linear scalar value
    # @return [Numeric] The equivalent magnitude on this scale
    # @api public
    def magnitude(scalar = scalar)
      terms.reduce(1.0) do |prod, term|
        prod * term.magnitude(scalar)
      end
    end

    # Multiply this unit by another unit, term, or number.
    # @param other [Unitwise::Unit, Unitwise::Term, Numeric]
    # @return [Unitwise::Unit]
    # @api public
    def *(other)
      if other.respond_to?(:terms)
        self.class.new(terms + other.terms)
      elsif other.respond_to?(:atom)
        self.class.new(terms << other)
      elsif other.is_a?(Numeric)
        self.class.new(terms.map { |t| t * other })
      else
        fail TypeError, "Can't multiply #{self} by #{other}."
      end
    end

    # Divide this unit by another unit,term, or number.
    # @param other [Unitwise::Unit, Unitwise::Term, Numeric]
    # @return [Unitwise::Unit]
    # @api public
    def /(other)
      if other.respond_to?(:terms)
        self.class.new(terms + other.terms.map { |t| t ** -1 })
      elsif other.respond_to?(:atom)
        self.class.new(terms << other ** -1)
      elsif other.is_a?(Numeric)
        self.class.new(terms.map { |t| t / other })
      else
        fail TypeError, "Can't divide #{self} by #{other}."
      end
    end

    # Raise this unit to a numeric power.
    # @param other [Numeric]
    # @return [Unitwise::Unit]
    # @api public
    def **(other)
      if other.is_a?(Numeric)
        self.class.new(terms.map { |t| t ** other })
      else
        fail TypeError, "Can't raise #{self} to #{other}."
      end
    end

    # A string representation of this unit.
    # @param mode [:symbol] The mode used to represent the unit
    # (:primary_code, :names, :secondary_code)
    # @return [String]
    # @api public
    def to_s(mode = nil)
      expression(mode)
    end

    # A collection of the possible string representations of this unit.
    # Primarily used by Unitwise::Search.
    # @return [Array]
    # @api public
    def aliases
      [:names, :primary_code, :secondary_code, :symbol].map do |mode|
        to_s(mode)
      end.uniq
    end
    memoize :aliases

    # The default mode to use for inspecting and printing.
    # @return [Symbol]
    # @api semipublic
    def mode
      terms
      @mode || :primary_code
    end

  end
end
