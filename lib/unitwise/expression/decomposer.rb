module Unitwise
  module Expression
    class Decomposer
      class << self
        def parser
          @parser ||= Parser.new
        end

        def transformer
          @transformer ||= Transformer.new
        end
      end

      attr_reader :expression

      def initialize(expression)
        @expression = expression
      end

      def parse
        @parse ||= self.class.parser.parse(expression)
      end

      def transform
        @transform ||= self.class.transformer.apply(parse)
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