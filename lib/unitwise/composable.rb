module Unitwise
  module Composable
    def composition
      root_terms.reduce(SignedMultiset.new) do |s, t|
        s.increment(t.atom.key, t.exponent); s
      end
    end
  end
end