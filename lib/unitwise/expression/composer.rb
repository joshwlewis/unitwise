module Unitwise
  module Expression
    class Composer
      attr_reader :terms, :mode
      def initialize(terms, mode)
        @terms  = terms
        @mode = mode || :primary_code
      end

      def set
        @set ||= terms.reduce(SignedMultiset.new) do |s, t|
          identifier = { :f => t.factor,
                         :p => (t.prefix.to_s(mode) if t.prefix),
                         :a => (t.atom.to_s(mode) if t.atom) }
          s.increment(identifier, t.exponent); s
        end
      end

      def numerator
        @numerator ||= set.select{|k,v| v > 0}.map do |k,v|
          "#{k[:f] if k[:f] != 1}#{k[:p]}#{k[:a]}#{v if v != 1}"
        end.select{|t| !t.empty?}.join('.')
      end

      def denominator
        @denominator ||= set.select{|k,v| v < 0}.map do |k,v|
          "#{k[:f] if k[:f] != 1}#{k[:p]}#{k[:a]}#{-v if v != -1}"
        end.select{|t| !t.empty?}.join('.')
      end

      def expression
        @expression = []
        @expression << (numerator.empty? ? '1' : numerator)
        (@expression << denominator) unless denominator.empty?
        @expression.join('/')
      end
    end
  end
end