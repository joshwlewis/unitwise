module Unitwise
  class Expression
    attr_reader :string
    class << self

      def sign
        "(?<sign>[+-])"
      end

      def digits
        "(?<digits>\\d+)"
      end

      def factor
        "(?<factor>#{digits})"
      end

      def exponent
        "(?<exponent>#{sign}?#{digits})"
      end

      def prefixes
        @prefixes ||= CodeList.create(Prefix.all)
      end

      def prefix
        "(?<prefix>#{prefixes.map {|c| Regexp.escape c}.join("|")})"
      end

      def nonmetric_atoms
        @atoms ||= CodeList.create(Atom.all.select{|a| !a.metric})
      end

      def metric_atoms
        @prefixable_atoms ||= CodeList.create(Atom.all.select{|a| a.metric?})
      end

      def nonmetric_atom
        "(?<atom>#{nonmetric_atoms.map { |c| Regexp.escape c}.join("|")})"
      end

      def metric_atom
        "(?<atom>#{metric_atoms.map{ |c| Regexp.escape c}.join("|")})"
      end

      def simple_unit
        "(?<simple_unit>#{nonmetric_atom}|#{prefix}?#{metric_atom})"
      end

      def annotatable
        "(?<annotatable>#{simple_unit}#{exponent}?)"
      end

      def annotation
        "(?<annotation>{.*})"
      end

      def expression
        "(?<expression>.+)"
      end

      def operator
        "(?<operator>[\\/\\.])"
      end

      def term
        "(?<term>#{annotatable}#{annotation}?|#{annotation}|#{factor}|\\(#{expression}\\))"
      end

      def term_operator
        "(?<term_operator>#{operator})"
      end

      def expression_operator
        "(?<expression_operator>#{operator})"
      end

      def matcher
        "^#{term_operator}#{term}|#{term}#{expression_operator}#{expression}|#{term}$"
      end
    end

    def initialize(string, expression_sign=1)
      @string = string
      @expression_sign = expression_sign
    end

    def match
      @match ||= Regexp.new(self.class.matcher).match(string)
    end

    def other_expression
      self.class.new(match[:expression], other_sign) if match[:expression]
    end

    def expression_sign
      @expression_sign ||= 1
    end

    def term_sign
      expression_sign * (self.term_operator == '/' ? -1 : 1)
    end

    def other_sign
      expression_sign * (self.expression_operator == '/' ? -1 : 1)
    end

    def exponent
      if exponent = match[:exponent]
        term_sign * exponent.to_i
      else
        term_sign
      end
    end

    def expressions
      expressions = [self]
      if other_expression
        expressions += other_expression.expressions
      else
        expressions
      end
    end

    def method_missing(method, *args, &block)
      if match.names.include?(method.to_s)
        match[method]
      end
    end

  end
end