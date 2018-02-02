# frozen_string_literal: true

module Unitwise
  module Expression
    # Special parser to prioritise parsing of expressions without prefixes.
    #
    # This is added as prefixed matches can take precedence over non-prefixed
    # :symbol matches. An example of this would be the expression "ft".
    #
    #   # Unitwise::Expression::Parser.new.parse("ft")
    #   # => {
    #   #      :left => {
    #   #        :term => {
    #   #          :prefix => {
    #   #            :prefix_code => "f"@0
    #   #          },
    #   #          :atom => {
    #   #            :atom_code => "t"@1
    #   #          }
    #   #        }
    #   #      }
    #   #    }
    #
    # Where in most common use cases, it is probably more intuitive to have "ft"
    # be matched to the atom "foot":
    #
    #   # Unitwise::Expression::AtomicParser.new(:symbol).parse("ft")
    #   # => {
    #   #      :left => {
    #   #        :term => {
    #   #          :atom => {
    #   #            :atom_code => "ft"@0
    #   #          }
    #   #        }
    #   #      }
    #   #    }
    #
    # AtomicParser should only be needed for :primary_code, :secondary_code and
    # :symbol type matches
    #
    class AtomicParser < Parslet::Parser
      attr_reader :key

      def initialize(key = :primary_code)
        @key                 = key
        @atom_matcher        = Matcher.atom(key)
        @metric_atom_matcher = Matcher.metric_atom(key)
      end

      private

      attr_reader :atom_matcher, :metric_atom_matcher

      root :expression

      rule(:atom) { atom_matcher.as(:atom_code) }
      rule(:metric_atom) { metric_atom_matcher.as(:atom_code) }

      rule(:simpleton) do
        metric_atom.as(:atom) | atom.as(:atom)
      end

      rule(:annotation) do
        str('{') >> match['^}'].repeat.as(:annotation) >> str('}')
      end

      rule(:digits) { match['0-9'].repeat(1) }

      rule(:integer) { (str('-').maybe >> digits).as(:integer) }

      rule(:fixnum) do
        (str('-').maybe >> digits >> str('.') >> digits).as(:fixnum)
      end

      rule(:number) { fixnum | integer }

      rule(:exponent) { integer.as(:exponent) }

      rule(:factor) { number.as(:factor) }

      rule(:operator) { (str('.') | str('/')).as(:operator) }

      rule(:term) do
        (
          ((factor >> simpleton) | simpleton | factor) >>
            exponent.maybe >>
            annotation.maybe
        ).as(:term)
      end

      rule(:group) do
        (factor.maybe >> str('(') >> expression.as(:nested) >> str(')') >>
          exponent.maybe).as(:group)
      end

      rule(:expression) do
        (group | term).as(:left).maybe >>
          (operator >> expression.as(:right)).maybe
      end
    end
  end
end
