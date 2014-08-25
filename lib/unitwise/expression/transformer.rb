module Unitwise
  module Expression
    # Transformer is responsible for turning a Unitwise::Expression::Parser
    # hash result into a collection of Unitwise::Terms.
    class Transformer < Parslet::Transform

      rule(:integer => simple(:i)) { i.to_i }
      rule(:fixnum => simple(:f)) { f.to_f }

      rule(:prefix_code => simple(:c)) { |x| Prefix.find(x[:c], x[:mode]) }
      rule(:atom_code => simple(:c))   { |x| Atom.find(x[:c], x[:mode]) }
      rule(:term => subtree(:h))       { Term.new(h) }

      rule(:operator => simple(:o), :right => simple(:r)) do
        o == '/' ? r ** -1 : r
      end

      rule(:left => simple(:l), :operator => simple(:o),
            :right => simple(:r)) do
        o == '/' ? l / r : l * r
      end

      rule(:left => simple(:l)) { l }

      rule(:group => { :factor => simple(:f),
            :nested => simple(:n), :exponent => simple(:e) }) do
        (n ** e) * f
      end

      rule(:group => { :nested => simple(:n) , :exponent => simple(:e) }) do
        n ** e
      end

      rule(:group => { :nested => simple(:n) }) { n }
    end
  end
end
