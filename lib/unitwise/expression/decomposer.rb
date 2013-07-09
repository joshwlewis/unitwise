module Unitwise
  module Expression
    class Decomposer

      PARSERS = [:primary_code, :secondary_code, :names, :slugs, :symbol].map do |t|
        Parser.new(t)
      end

      TRANSFORMER = Transformer.new

      attr_reader :expression

      def initialize(expression)
        @expression = expression.to_s
        if terms.nil? || terms.empty?
          raise ExpressionError, "Could not evaluate '#{@expression}'."
        end
      end

      def parse
        PARSERS.reduce(nil) do |m, p|
          if prs = p.parse(expression) rescue next
            return prs
          end
        end
      end

      def transform
        @transform ||= TRANSFORMER.apply(parse)
      end

      def terms
        if transform.respond_to?(:terms)
          transform.terms
        else
          Array(transform)
        end
      end

    end
  end
end