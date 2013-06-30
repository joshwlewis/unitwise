module Unitwise
  class Unit
    include Unitwise::Composable
    attr_writer :terms, :expression

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
      if other.respond_to?(:terms)
        self.class.new(terms + other.terms)
      else
        raise ArgumentError, "Can't multiply #{inspect} by #{other}."
      end
    end

    def /(other)
      if other.respond_to?(:terms)
        self.class.new(terms + other.terms.map{ |t| t ** -1})
      else
        raise ArgumentError, "Can't divide #{inspect} by #{other}."
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