module Unitwise
  class Unit
    include Unitwise::Composable

    def initialize(expression)
      @expression = Expression.new(expression.to_s)
    end

    def expressions
      @expression.expressions
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

    def to_s
      @expression.to_s
    end

    def inspect
      "<#{self.class} #{to_s}>"
    end

  end
end