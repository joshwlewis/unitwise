module Unitwise
  module Expression
    class Transformer < Parslet::Transform
      attr_reader :key
      def initialize(key=:codes)
        @key = key
        super()
      end
      rule(integer: simple(:i)) { i.to_i }
      rule(fixnum: simple(:f)) { f.to_f }

      rule(prefix_code: simple(:c)) { Prefix.find(c) }
      rule(atom_code: simple(:c)) { Atom.find(c) }
      rule(term: subtree(:h)) { Term.new(h) }

      rule(left: simple(:l), operator: simple(:o), right: simple(:r)) do
        o == '/' ? l / r : l * r
      end

      rule(left: simple(:l)) { l }

      rule(group: { nested: simple(:n) , exponent: simple(:e)}) { n ** e }

      rule(group: { nested: simple(:n) }) { n }
    end
  end
end