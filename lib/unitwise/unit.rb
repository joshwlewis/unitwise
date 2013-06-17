module Unitwise
  class Unit
    include Unitwise::Composable
    attr_reader :expression
    def initialize(expression)
      if expression.is_a?(Expression)
        @expression = expression.dup
      else
        @expression = Expression.new(expression.to_s)
      end
    end

    def dup
      self.class.new(expression)
    end

    def expressions
      expression.expressions
    end

    def terms
      @terms ||= expressions.map do |e|
        Term.new(atom_code: e.atom, prefix_code: e.prefix, exponent: e.exponent, factor: e.factor)
      end
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

    def **(int)
      if int.is_a?(Integer)
        exps = Array.new.fill("(#{expression})", 0, int.abs - 1).join('.')
        if int < 0
          self.class.new(Simplifier.new("(#{expression})/(#{exps})").expression)
        else
          self.class.new(Simplifier.new("(#{expression}).#{exps}").expression)
        end
      end
    end

    def to_s
      expression.to_s
    end

    def inspect
      "<#{self.class} #{to_s}>"
    end

  end
end