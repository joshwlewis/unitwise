module Unitwise
  module Expression
    class Decomposer

      MODES = [:primary_code, :secondary_code, :names, :slugs, :symbol]

      PARSERS = MODES.reduce({}) do |hash, mode|
        hash[mode] = Parser.new(mode); hash
      end

      TRANSFORMER = Transformer.new

      attr_reader :expression, :mode

      def initialize(expression)
        @expression = expression.to_s
        if terms.nil? || terms.empty?
          fail ExpressionError, "Could not evaluate '#{@expression}'."
        end
      end

      def parse
        @parse ||= PARSERS.reduce(nil) do |null,(mode, parser)|
          parsed = parser.parse(expression) rescue next
          @mode = mode
          break parsed
        end
      end

      def transform
        @transform ||= TRANSFORMER.apply(parse, :mode => mode)
      end

      def terms
        @terms ||= if transform.respond_to?(:terms)
          transform.terms
        else
          Array(transform)
        end
      end

    end
  end
end