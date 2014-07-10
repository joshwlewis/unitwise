module Unitwise
  module Expression
    class Matcher
      class << self
        def atom(mode)
          new(Atom.all, mode).alternative
        end

        def metric_atom(mode)
          new(Atom.all.select(&:metric?), mode).alternative
        end

        def prefix(mode)
          new(Prefix.all, mode).alternative
        end
      end

      attr_reader :collection, :mode

      def initialize(collection, mode=:primary_code)
        @collection = collection
        @mode = mode
      end

      def strings
        @stings ||= collection.map(&mode).flatten.compact.sort do |x,y|
          y.length <=> x.length
        end
      end

      def matchers
        @matchers ||= strings.map {|s| Parslet::Atoms::Str.new(s) }
      end

      def alternative
        @alternative ||= Parslet::Atoms::Alternative.new(*matchers)
      end

    end
  end
end
