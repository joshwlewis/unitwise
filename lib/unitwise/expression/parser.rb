# frozen_string_literal: true

module Unitwise
  module Expression
    # Parses a string expression into a hash tree representing the
    # expression's terms, prefixes, and atoms.
    class Parser < Parslet::Parser
      attr_reader :key
      
      def initialize(key = :primary_code)
        @key                 = key
        @atom_matcher        = Matcher.atom(key)
        @metric_atom_matcher = Matcher.metric_atom(key)
        @prefix_matcher      = Matcher.prefix(key)
      end

      private

      attr_reader :atom_matcher, :metric_atom_matcher, :prefix_matcher

      root :expression

      rule(:atom) { atom_matcher.as(:atom_code) }
      rule(:metric_atom) { metric_atom_matcher.as(:atom_code) }
      rule(:prefix) { prefix_matcher.as(:prefix_code) }

      rule(:simpleton) do
        prefix.as(:prefix) >> metric_atom.as(:atom) | atom.as(:atom)
      end

      rule(:annotation) do
        str("{") >> match["^}"].repeat.as(:annotation) >> str("}")
      end

      rule(:digits) { match["0-9"].repeat(1) }

      rule(:integer) { (str("-").maybe >> digits).as(:integer) }

      rule(:fixnum) do
        (str("-").maybe >> digits >> str(".") >> digits).as(:fixnum)
      end

      rule(:number) { fixnum | integer }

      rule(:exponent) { integer.as(:exponent) }

      rule(:factor) { number.as(:factor) }

      rule(:operator) { (str(".") | str("/")).as(:operator) }

      rule(:term) do
        ((factor >> simpleton | simpleton | factor) >>
          exponent.maybe >> annotation.maybe).as(:term)
      end

      rule(:group) do
        (factor.maybe >> str("(") >> expression.as(:nested) >> str(")") >>
          exponent.maybe).as(:group)
      end

      rule(:expression) do
        (group | term).as(:left).maybe >>
          (operator >> expression.as(:right)).maybe
      end
    end
  end
end
