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
        Decomposer.new(expression).terms
      end
    end
  end
end