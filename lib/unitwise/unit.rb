module Unitwise
  class Unit
    include Unitwise::Composable

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

    def functional(x=scalar, forward=true)
      terms.first.functional(x, forward)
    end

    def dup
      self.class.new(expression)
    end

    def depth
      terms.map(&:depth).max + 1
    end

    def terminal?
      depth <= 3
    end

    def root_terms
      terms.flat_map(&:root_terms)
    end

    def scalar
      if terms.empty?
        1
      else
        terms.map(&:scalar).inject(&:*)
      end
    end

    def *(other)
      if other.respond_to?(:terms)
        self.class.new(terms + other.terms)
      elsif other.respond_to?(:atom)
        self.class.new(terms << other)
      elsif other.is_a?(Numeric)
        self.class.new(terms.map{ |t| t * other })
      else
        raise TypeError, "Can't multiply #{inspect} by #{other}."
      end
    end

    def /(other)
      if other.respond_to?(:terms)
        self.class.new(terms + other.terms.map{ |t| t ** -1})
      elsif other.respond_to?(:atom)
        self.class.new(terms << other ** -1)
      else
        raise TypeError, "Can't divide #{inspect} by #{other}."
      end
    end

    def **(number)
      self.class.new(terms.map{ |t| t ** number })
    end

    def to_s
      expression
    end

    def inspect
      "<#{self.class} #{to_s}>"
    end

  end
end