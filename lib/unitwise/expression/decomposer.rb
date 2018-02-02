# frozen_string_literal: true

module Unitwise
  module Expression
    # The decomposer is used to turn string expressions into collections of
    # terms. It is responsible for executing the parsing and transformation
    # of a string, as well as caching the results.
    class Decomposer
      ATOMIC_MODES = %i[primary_code secondary_code symbol].freeze
      MODES = %i[primary_code secondary_code names slugs symbol].freeze

      class << self
        # Parse an expression to an array of terms and cache the results
        def parse(expression)
          expression = expression.to_s

          if cache.key?(expression)
            cache[expression]
          elsif (decomposer = new(expression))
            cache[expression] = decomposer
          end
        end

        def parsers
          return @parsers if !@parsers.nil? && @parsers.any?

          @parsers = ATOMIC_MODES.each_with_object({}) do |mode, parsers|
            parsers[AtomicParser.new(mode)] = mode
          end

          MODES.each { |mode| @parsers[Parser.new(mode)] = mode }

          @parsers = parsers.to_h
        end

        def transformer
          @transformer = Transformer.new
        end

        private

        # A simple cache to prevent re-decomposing the same units
        # api private
        def cache
          @cache ||= {}
        end

        # Reset memoized data. Allows rebuilding of parsers, transformers, and
        # the cache after list of atoms has been modified.
        def reset
          @parsers = nil
          @transformer = nil
          @cache = nil
        end
      end

      attr_reader :expression, :mode

      def initialize(expression)
        @expression = expression.to_s

        if expression.empty? || terms.nil? || terms.empty?
          fail(ExpressionError, "Could not evaluate '#{expression}'.")
        end
      end

      def parse
        self.class.parsers.reduce(nil) do |_, (parser, mode)|
          begin
            parsed = parser.parse(expression)
          rescue Parslet::ParseFailed
            next nil
          end

          @mode = mode
          break parsed
        end
      end

      def transform
        @transform ||= self.class.transformer.apply(parse, mode: mode)
      end

      def terms
        @terms ||=
          if transform.respond_to?(:terms)
            transform.terms
          else
            Array(transform)
          end
      end
    end
  end
end
