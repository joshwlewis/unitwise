module Unitwise
  module Expression
    class Decomposer

      PARSERS = [:codes, :names, :symbol].map{ |t| Parser.new(t) }

      attr_reader :expression
      attr_accessor :key, :parsed

      def initialize(expression)
        @expression = expression
        self.parse
      end

      def parse
        PARSERS.each do |p|
          if prs = p.parse(expression) rescue next
            self.parsed = prs
            self.key = p.key
            break
          end
        end
        parsed
      end

      def transform
        @transform ||= Transformer.new(key).apply(parsed)
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