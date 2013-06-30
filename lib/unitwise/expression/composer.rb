module Unitwise
  module Expression
    class Composer
      attr_reader :terms
      def initialize(input)
        if input.respond_to?(:terms)
          @terms = input.terms
        elsif input.respond_to?(:each)
          @terms = input
        else
          @terms = Expression.decompose(input.to_s)
        end
      end

      def set
        @set ||= terms.reduce(SignedMultiset.new) do |s, t|
          s.increment({f: t.factor, p: t.prefix_code, a: t.atom_code}, t.exponent); s
        end
      end

      def numerator
        @numerator ||= set.select{|k,v| v >= 1}.map do |k,v|
          "#{k[:f] if k[:f] != 1}#{k[:p]}#{k[:a]}#{v if v > 1}"
        end.select{|t| !t.empty?}.join('.')
      end

      def denominator
        @denominator ||= set.select{|k,v| v <= -1}.map do |k,v|
          "#{k[:f] if k[:f] != 1}#{k[:p]}#{k[:a]}#{-v if v < -1}"
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