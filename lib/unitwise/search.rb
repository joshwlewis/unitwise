module Unitwise
  module Search
    class << self
      # An abbreviated list of possible units. These are known combinations 
      # of atoms and prefixes. Since units can be combined to create more
      # complex units (and thus an infinite number), a full list can't be
      # provided.
      # @return [Array] A list of known units
      # @api public
      def all
        @all ||= begin
          units = []
          Atom.all.each do |a|
            units << build(a)
            Unitwise::Prefix.all.each { |p| units << build(a,p) } if a.metric?
          end
          units
        end
      end

      # Search the list of known units for a match. Note that this cannot
      # find all possible units, only simple combinations of atoms and prefixes.
      # @param term [String, Regexp] The term to search for
      # @return [Array] A list of matching units.
      # @api public
      def search(term)
        all.select do |unit|
          unit.aliases.any? { |str| Regexp.new(term).match(str) }
        end
      end

      private

      # Helper method for building a new unit by a known atom and prefix.
      # @param atom [Unitwise::Atom]
      # @param prefix [Unitwise::Prefix, nil]
      # @return [Unitwise::Unit]
      # @api private
      def build(atom, prefix=nil)
        Unit.new([Term.new(:atom => atom, :prefix => prefix)])
      end
    end
  end
end
