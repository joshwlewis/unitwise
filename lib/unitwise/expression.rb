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

      def remnant
        "(?<remnant>.+)"
      end

      def nestor
        "\\((?<nestor>[^)]+[^(]*)\\)"
      end

      def operator
        "(?<operator>[\\/\\.])"
      end

      def term
        "(?<term>#{annotatable}#{annotation}?|#{annotation}|#{factor}|#{nestor})"
      end

      def term_operator
        "(?<term_operator>#{operator})"
      end

      def remnant_operator
        "(?<remnant_operator>#{operator})"
      end

      def matcher
        "^#{term_operator}#{term}|#{term}#{remnant_operator}#{remnant}|#{term}$"
      end
    end

    def initialize(string, sign=nil)
      @string = string
      @sign = sign
    end

    def match
      @match ||= Regexp.new(self.class.matcher).match(string)
    end

    def remnant
      self.class.new(match[:remnant], remnant_sign) if match[:remnant]
    end

    def nestor
      self.class.new(match[:nestor], term_sign) if match[:nestor]
    end

    def sign
      @sign ||= 1
    end

    def term_sign
      sign * (self.term_operator == '/' ? -1 : 1)
    end

    def remnant_sign
      sign * (self.remnant_operator == '/' ? -1 : 1)
    end

    def exponent
      if exponent = match[:exponent]
        term_sign * exponent.to_i
      else
        term_sign
      end
    end

    def factor
      match[:factor] ? match[:factor].to_i : 1
    end

    def expressions
      expressions = nestor ? nestor.expressions : [self]
      expressions += remnant.expressions if remnant
      expressions
    end

    def atoms
      expressions.map(&:atom)
    end

    def exponents
      expressions.map(&:exponent)
    end

    def prefixes
      expressions.map(&:prefix)
    end

    def factors
      expressions.map(&:factor)
    end

    def method_missing(method, *params, &block)
      if match.names.include?(method.to_s) && params.empty?
        match[method]
      else
        super(method, args, &block)
      end
    end

    def to_s
      string
    end

  end
end