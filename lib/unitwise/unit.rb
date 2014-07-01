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
    def initialize(input)
      case input
      when Compatible
        @expression = input.expression
      when String, Symbol
        @expression = input.to_s
      else
        @terms = input
        @expression = Expression.compose(input)
      end
      freeze
    end

    def terms
      @terms || Expression.decompose(expression)
    end

    def atoms
      terms.map(&:atom)
    end
    memoize :atoms

    def special?
      terms.count == 1 && terms.all?(&:special?)
    end
    memoize :special?

    def depth
      terms.map(&:depth).max + 1
    end
    memoize :depth

    def root_terms
      terms.map(&:root_terms).flatten
    end
    memoize :root_terms

    def scalar(magnitude = 1.0)
      terms.reduce(1.0) do |prod, term|
        prod * term.scalar(magnitude)
      end
    end

    def magnitude(scalar = scalar)
      terms.reduce(1.0) do |prod, term|
        prod * term.magnitude(scalar)
      end
    end

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

    def /(other)
      if other.respond_to?(:terms)
        self.class.new(terms + other.terms.map { |t| t ** -1 })
      elsif other.respond_to?(:atom)
        self.class.new(terms << other ** -1)
      else
        fail TypeError, "Can't divide #{self} by #{other}."
      end
    end

    def **(other)
      if other.is_a?(Numeric)
        self.class.new(terms.map { |t| t ** other })
      else
        fail TypeError, "Can't raise #{self} to #{other}."
      end
    end

    def to_s
      expression
    end
  end
end
