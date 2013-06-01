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
        Unitwise.prefixes.map(&:codes).flatten
      end

      def prefix
        "(?<prefix>#{prefixes.map {|c| Regexp.escape c}.join("|")})"
      end

      def atoms
        Unitwise.units.map(&:codes).flatten.compact
      end

      def prefixable_atoms
        Unitwise.units.select(&:metric).map(&:codes).flatten.compact
      end

      def atom
        "(?<atom>#{atoms.map {|c| Regexp.escape c}.join("|")})"
      end

      def prefixable_atom
        "(?<atom>#{prefixable_atoms.map{|c| Regexp.escape c}.join("|")})"
      end

      def simple_unit
        "(?<simple_unit>#{prefix}#{prefixable_atom}|#{atom})"
      end

      def power
        "(?<power>#{simple_unit}#{exponent}?)"
      end

      def annotation
        "(?<annotation>{.*})"
      end

      def expression
        "(?<expression>.+)"
      end

      def operator
        "(?<operator>[\\/\\.\\*])"
      end

      def term
        "(?<term>#{power}#{annotation}?|#{annotation}|#{factor}|\\(#{expression}\\))"
      end

      def matcher
        "/#{term}|#{term}#{operator}#{expression}|#{term}"
      end
    end

    def initialize(string)
      @string = string
    end

    def match
      @match ||= Regexp.new(self.class.matcher).match(string)
    end

    def other_expression
      self.class.new(match[:expression]) if match[:expression]
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