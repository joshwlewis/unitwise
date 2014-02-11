module Unitwise
  module Expression
    class Decomposer

      METHODS = [:primary_code, :secondary_code, :names, :slugs, :symbol]

      PARSERS = METHODS.reduce({}) do |hash, method|
        hash[method] = Parser.new(method); hash
      end

      TRANSFORMER = Transformer.new

      attr_reader :expression

      def initialize(expression)
        @expression = expression.to_s
        if terms.nil? || terms.empty?
          raise ExpressionError, "Could not evaluate '#{@expression}'."
        end
      end

      def transform
        PARSERS.reduce(nil) do |foo, (method, parser)|
          if parsed = parser.parse(expression) rescue next
            return TRANSFORMER.apply(parsed, key: method)
          end
        end
      end

      def terms
        @terms ||= begin
          transformation = transform
          if transformation.respond_to?(:terms)
            transformation.terms
          else
            Array(transformation)
          end
        end
      end

    end
  end
end