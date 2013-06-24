module Unitwise
  class Unit
    include Unitwise::Composable
    attr_reader :expression
    def initialize(expression)
      @expression = expression.to_s
    end

    def terms
      @terms ||= Expression.parse(expression).value
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

    def scale
      if terms.empty?
        1
      else
        terms.map(&:scale).inject(&:*)
      end
    end

    def *(other)
      if other.respond_to?(:expression)
        self.class.new(Simplifier.new("(#{expression}).(#{other.expression})").expression)
      else
        raise ArgumentError, "Can't multiply #{inspect} by #{other}."
      end
    end

    def /(other)
      if other.respond_to?(:expression)
        self.class.new(Simplifier.new("(#{expression})/(#{other.expression})").expression)
      else
        raise ArgumentError, "Can't divide #{inspect} by #{other}."
      end
    end

    def **(number)
      self.class.new(Simplifier.new("(#{expression})#{number}").expression)
    end

    def to_s
      expression
    end

    def inspect
      "<#{self.class} #{to_s}>"
    end

  end
end