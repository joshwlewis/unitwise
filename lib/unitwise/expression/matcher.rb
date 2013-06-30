module Unitwise
  module Expression
    class Matcher
      class << self
        def atom_codes
          @atom_codes ||= new(Atom.all).alternative
        end

        def metric_atom_codes
          @metric_atom_codes ||= new(Atom.all.select(&:metric?)).alternative
        end

        def prefix_codes
          @prefix_codes ||= new(Prefix.all).alternative
        end
      end

      attr_reader :collection, :method

      def initialize(collection, method=:codes)
        @collection = collection
        @method = method
      end

      def strings
        @stings ||= collection.map(&method).flatten.compact.sort do |x,y|
          y.length <=> x.length
        end
      end

      def strs
        @strs ||= strings.map{|s| Parslet::Atoms::Str.new(s) }
      end

      def alternative
        @alternative ||= Parslet::Atoms::Alternative.new(*strs)
      end

    end
  end
end