require 'parslet'

require 'unitwise/expression/matcher'
require 'unitwise/expression/parser'
require 'unitwise/expression/transformer'
require 'unitwise/expression/composer'
require 'unitwise/expression/decomposer'

module Unitwise
  module Expression
    class << self
      def compose(terms)
        Composer.new(terms).expression
      end

      def decompose(expression)
        begin
          Decomposer.new(expression).terms
        rescue ExpressionError
          nil
        end
      end
    end
  end
end