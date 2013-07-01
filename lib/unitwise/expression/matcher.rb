module Unitwise
  module Expression
    class Matcher
      class << self
        def atom(method)
          new(Atom.all, method).alternative
        end

        def metric_atom(method)
          new(Atom.all.select(&:metric?), method).alternative
        end

        def prefix(method)
          @prefix_codes ||= new(Prefix.all, method).alternative
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