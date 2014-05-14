module Unitwise
  # A Unit is essentially a collection of Unitwise::Term. Terms can be combined
  # through multiplication or division to create a unit. A unit does not have
  # a magnitude, but it does have a scale.
  class Unit
    liner :expression, :terms
    include Unitwise::Compatible

    # Create a new unit. You can send an expression or a collection of terms
    # @param input [String, Unit, [Term]] A string expression, a unit, or a
    # collection of tems.
    def initialize(input)
      if input.respond_to?(:expression)
        @expression = input.expression
      elsif input.respond_to?(:each)
        @terms = input
      else
        @expression = input.to_s
      end
    end

    def expression
      @expression ||= (Expression.compose(@terms) if @terms)
    end

    def terms
      @terms ||= (Expression.decompose(@expression) if @expression)
    end

    def atoms
      terms.map(&:atom)
    end

    def special?
      terms.count == 1 && terms.all?(&:special?)
    end


    def depth
      terms.map(&:depth).max + 1
    end

    def root_terms
      terms.flat_map(&:root_terms)
    end

    def scalar(x = 1)
      terms.reduce(1) do |prod, term|
        prod * term.scalar(x)
      end
    end

    def inverse_scalar(x = 1)
      terms.reduce(1) do |prod, term|
        prod * term.inverse_scalar(x)
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
