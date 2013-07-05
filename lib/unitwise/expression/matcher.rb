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
          new(Prefix.all, method).alternative
        end
      end

      attr_reader :collection, :method

      def initialize(collection, method=:codes)
        @collection = collection
        @method = method
      end

      def strx(string)
        if string =~ /[A-Z]|\W/
          string.split(//).map do |c|
            if c =~ /\s/
              str(c) | str('_')
            elsif c =~ /\W/
              (str(c) | str('_')).maybe
            elsif c =~ /[A-Z]/
              str(c) | str(c.downcase)
            else
              str(c)
            end
          end.reduce(:>>)
        else
          str(string)
        end
      end

      def str(string)
        Parslet::Atoms::Str.new(string)
      end

      def strings
        @stings ||= collection.map(&method).flatten.compact.sort do |x,y|
          y.length <=> x.length
        end
      end

      def matchers
        @matchers ||= strings.map do |s|
          method == :names ? strx(s) : str(s)
        end
      end

      def alternative
        @alternative ||= Parslet::Atoms::Alternative.new(*matchers)
      end

    end
  end
end