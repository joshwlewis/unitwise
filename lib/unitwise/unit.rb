module Unitwise
  class Unit
    attr_accessor :terms

    def initialize(expression)
      @expression = Expression.new(expression.to_s)
    end

    def expressions
      @expression.expressions
    end

    def terms
      @terms ||= expressions.map do |e|
        Term.new(atom: e.atom, prefix: e.prefix, exponent: e.exponent)
      end
    end
  end
end