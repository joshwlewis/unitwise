module Unitwise
  module MatchList
    class << self
      def atom_codes
        @atom_codes ||= create(Atom.all)
      end

      def metric_atom_codes
        @metric_atom_codes ||= create(Atom.all.select(&:metric?))
      end

      def prefix_codes
        @prefix_codes ||= create(Prefix.all)
      end

      def create(collection, method=:codes)
        collection.inject([]) do |a,i|
          i.send(method).each do |c|
            a << Regexp.escape(c) if c && !a.include?(c)
          end
          a
        end.sort{|x,y| y.length <=> x.length }.join('|')
      end
    end
  end
end